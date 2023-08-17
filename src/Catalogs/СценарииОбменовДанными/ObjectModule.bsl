///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		
		ИспользоватьРегламентноеЗадание = Ложь;
		
	КонецЕсли;
	
	Если ИспользоватьРегламентноеЗадание И ОтключенАвтоматически Тогда
		
		ОтключенАвтоматически = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Удаляем регламентное задание при необходимости.
	Если ПометкаУдаления Тогда
		
		УдалитьРегламентноеЗадание(Отказ);
		
	КонецЕсли;
	
	// Обновляем кэш платформы для зачитывания актуальных настроек
	// сценария обмена данными процедурой ОбменДаннымиПовтИсп.НастройкиОбменаДанными.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РегламентноеЗаданиеGUID = "";
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьРегламентноеЗадание(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет удаление регламентного задания.
//
// Параметры:
//  Отказ                     - Булево - флаг отказа. Если в процессе выполнения процедуры были обнаружены ошибки,
//                                       то флаг отказа устанавливается в значение Истина.
//  РегламентноеЗаданиеОбъект - объект регламентного задания, которое необходимо удалить.
// 
Процедура УдалитьРегламентноеЗадание(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
			
	// Определяем регламентное задание.
	РегламентноеЗаданиеОбъект = Справочники.СценарииОбменовДанными.РегламентноеЗаданиеПоИдентификатору(РегламентноеЗаданиеGUID);
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		Попытка
			Если ОбщегоНазначения.РазделениеВключено() Тогда
				РегламентныеЗаданияСервер.УдалитьЗадание(РегламентноеЗаданиеОбъект);
			Иначе
				РегламентноеЗаданиеОбъект.Удалить();
			КонецЕсли;	
		Исключение
			СтрокаСообщения = НСтр("ru = 'Ошибка при удалении регламентного задания: %1'");
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, 
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбменДаннымиСервер.СообщитьОбОшибке(СтрокаСообщения, Отказ);
		КонецПопытки;
	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переводит текст на другой язык с использованием сервиса перевода текста.
//
// Параметры:
//  Текст        - Строка - произвольный текст.
//  ЯзыкПеревода - Строка - код языка в формате ISO 639-1, на который выполняется перевод.
//                          Например, "en".
//                          Если не указан, то перевод выполняется на текущий язык.
//  ИсходныйЯзык - Строка - код языка в формате ISO 639-1, с которого выполняется перевод.
//                          Например, "ru".
//                          Если не указан, то язык будет установлен сервисом перевода текста.
//
// Возвращаемое значение:
//  Строка
//
Функция ПеревестиТекст(Текст, ЯзыкПеревода = Неопределено, ИсходныйЯзык = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат Текст;
	КонецЕсли;
	
	Возврат ПеревестиТексты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Текст), ЯзыкПеревода, ИсходныйЯзык)[Текст];
	
КонецФункции

// Переводит тексты на другой язык с использованием сервиса перевода текста.
//
// Параметры:
//  Тексты - Массив из Строка - произвольные тексты.
//  ЯзыкПеревода - Строка - код языка в формате ISO 639-1, на который выполняется перевод.
//                          Например, "en".
//                          Если не указан, то перевод выполняется на текущий язык.
//  ИсходныйЯзык - Строка - код языка в формате ISO 639-1, с которого выполняется перевод.
//                          Например, "ru".
//                          Если не указан, то язык будет установлен сервисом перевода текста.
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//   * Ключ     - Строка - текст;
//   * Значение - Строка - перевод.
//
Функция ПеревестиТексты(Тексты, ЯзыкПеревода = Неопределено, ИсходныйЯзык = Неопределено) Экспорт
	
	ПроверитьНастройки();
	
	Если ЗначениеЗаполнено(ИсходныйЯзык) И ЯзыкПеревода = ИсходныйЯзык Тогда
		НайденныеПереводы = Новый Соответствие;
		Для Каждого Текст Из Тексты Цикл
			НайденныеПереводы.Вставить(Текст, Текст);
		КонецЦикла;
		Возврат НайденныеПереводы;
	КонецЕсли;
	
	НайденныеПереводы = НайтиПереводТекстов(Тексты, ЯзыкПеревода, ИсходныйЯзык);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСервисПереводаТекста") Тогда
		Возврат НайденныеПереводы;
	КонецЕсли;	
	
	ТекстыТребующиеПеревод = Новый Соответствие;
	МодульСервисаПереводаТекста = МодульСервисаПереводаТекста();
	МаксимальныйРазмерПорции = МодульСервисаПереводаТекста.МаксимальныйРазмерПорции();
	
	Для Каждого Текст Из Тексты Цикл
		Если ЗначениеЗаполнено(НайденныеПереводы[Текст]) Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(Текст) Тогда
			ТекстыТребующиеПеревод[Текст] = РазделитьТекстНаЧасти(Текст, МаксимальныйРазмерПорции, Символы.ПС + ".;!?, ");
		КонецЕсли;
	КонецЦикла;
	
	ОчередьПеревода = Новый Массив;
	Порция = Новый Массив;
	РазмерПорции = 0;
	
	Для Каждого ОписаниеТекста Из ТекстыТребующиеПеревод Цикл
		ФрагментыТекста = ОписаниеТекста.Значение;
		Для Каждого Фрагмент Из ФрагментыТекста Цикл
			Если РазмерПорции + СтрДлина(Фрагмент) > МаксимальныйРазмерПорции Тогда
				ОчередьПеревода.Добавить(Порция);
				Порция = Новый Массив;
				РазмерПорции = 0;
			КонецЕсли;
			Порция.Добавить(Фрагмент);
			РазмерПорции = РазмерПорции + СтрДлина(Фрагмент);
		КонецЦикла;
	КонецЦикла;
	Если ЗначениеЗаполнено(Порция) Тогда
		ОчередьПеревода.Добавить(Порция);
	КонецЕсли;
	
	ПереведенныеФрагменты = Новый Соответствие;
	
	Для Каждого Порция Из ОчередьПеревода Цикл
		Попытка
			Переводы = МодульСервисаПереводаТекста.ПеревестиТексты(Порция, ЯзыкПеревода, ИсходныйЯзык);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Перевод текста'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Перечисления.СервисыПереводаТекста, Константы.СервисПереводаТекста.Получить(), ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			Если Пользователи.ЭтоПолноправныйПользователь() Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
					"ru = 'Не удалось выполнить операцию по причине:
					|%1'"), ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Иначе
				ТекстОшибки = НСтр("ru = 'Не удалось выполнить операцию. Обратитесь к администратору.'");
			КонецЕсли;
			
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
		Для Каждого Перевод Из Переводы Цикл
			СохранитьПереводТекста(Перевод.Ключ, Перевод.Значение, ИсходныйЯзык, ЯзыкПеревода);
			ПереведенныеФрагменты.Вставить(Перевод.Ключ, Перевод.Значение);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ОписаниеТекста Из ТекстыТребующиеПеревод Цикл
		Текст = ОписаниеТекста.Ключ;
		ФрагментыТекста = ОписаниеТекста.Значение;

		ПереведенныеЧастиТекста = Новый Массив;
		Для Каждого Фрагмент Из ФрагментыТекста Цикл	
			ПереведенныеЧастиТекста.Добавить(ПереведенныеФрагменты[Фрагмент]);
		КонецЦикла;
		
		НайденныеПереводы.Вставить(Текст, СтрСоединить(ПереведенныеЧастиТекста, Символы.ПС));
	КонецЦикла;
	
	Возврат НайденныеПереводы;
	
КонецФункции

// Возвращает список языков, поддерживаемых сервисом перевода текста.
//
// Возвращаемое значение:
//  СписокЗначений:
//   * Значение - код языка;
//   * Представление - представление языка.
//
Функция ДоступныеЯзыки() Экспорт
	
	ПредставленияЯзыков = Новый Соответствие;
	Для Каждого КодЯзыка Из ПолучитьДопустимыеКодыЛокализации() Цикл
		ПредставленияЯзыков.Вставить(КодЯзыка, ПредставлениеКодаЛокализации(КодЯзыка));
	КонецЦикла;
	
	Результат = Новый СписокЗначений;
	
	МодульСервисаПереводаТекста = МодульСервисаПереводаТекста();
	Если МодульСервисаПереводаТекста = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		ДоступныеЯзыки = МодульСервисаПереводаТекста.ДоступныеЯзыки();
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Перевод текста'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Перечисления.СервисыПереводаТекста, Константы.СервисПереводаТекста.Получить(), ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		Если Пользователи.ЭтоПолноправныйПользователь() Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
				"ru = 'Не удалось выполнить операцию по причине:
				|%1'"), ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Иначе
			ТекстОшибки = НСтр("ru = 'Не удалось выполнить операцию. Обратитесь к администратору.'");
		КонецЕсли;
		
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Для Каждого КодЯзыка Из ДоступныеЯзыки Цикл
		Представление = ПредставленияЯзыков[КодЯзыка];
		Если ЗначениеЗаполнено(Представление) Тогда
			Результат.Добавить(КодЯзыка, ТРег(Представление));
		КонецЕсли;
	КонецЦикла;
	
	Результат.СортироватьПоПредставлению();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДоступенПереводТекста() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьСервисПереводаТекста");
	
КонецФункции

Функция СервисПереводаТекста() Экспорт
	
	Возврат Константы.СервисПереводаТекста.Получить();
	
КонецФункции

Процедура ПеревестиТекстыТабличногоДокумента(ТабличныйДокумент, ЯзыкПеревода, ИсходныйЯзык) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстыЯчеек = Новый Соответствие;
	
	Для НомерСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			Если ЗначениеЗаполнено(Область.Текст) Тогда
				Текст = УбратьПараметрыИзТекста(Область.Текст).Текст;
				ТекстыЯчеек.Вставить(Текст, Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ТекстыДляПеревода = Новый Массив;
	Для Каждого Элемент Из ТекстыЯчеек Цикл
		ТекстыДляПеревода.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Переводы = ПеревестиТексты(ТекстыДляПеревода, ЯзыкПеревода, ИсходныйЯзык);
	
	Для НомерСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			Если ЗначениеЗаполнено(Область.Текст) Тогда
				РезультатОбработки = УбратьПараметрыИзТекста(Область.Текст);
				Текст = РезультатОбработки.Текст;
				Если ЗначениеЗаполнено(Переводы[Текст]) Тогда
					Область.Текст = ВернутьПараметрыВТекст(Переводы[Текст], РезультатОбработки.Параметры);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Для Каждого МодульПровайдера Из МодулиСервисовПереводаТекста() Цикл
		МодульСервисаПереводаТекста = МодульПровайдера.Значение;
		Разрешения = МодульСервисаПереводаТекста.Разрешения();
		ЗапросРазрешений = МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения);
		ЗапросыРазрешений.Добавить(ЗапросРазрешений);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиПереводТекстов(Тексты, ЯзыкПеревода, ИсходныйЯзык)
	
	ТекстыДляПоиска = Новый Массив;
	ИдентификаторыТекстов = Новый Соответствие;
	Для Каждого Текст Из Тексты Цикл
		ИдентификаторТекста = ИдентификаторТекста(Текст);
		ТекстыДляПоиска.Добавить(ИдентификаторТекста);
		ИдентификаторыТекстов.Вставить(Текст, ИдентификаторТекста);
	КонецЦикла;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КэшПереводов.Текст КАК Текст,
	|	КэшПереводов.Перевод КАК Перевод,
	|	КэшПереводов.ИсходныйЯзык КАК ИсходныйЯзык
	|ИЗ
	|	РегистрСведений.КэшПереводов КАК КэшПереводов
	|ГДЕ
	|	КэшПереводов.Текст В(&Текст)
	|	И КэшПереводов.ЯзыкПеревода = &ЯзыкПеревода
	|	И КэшПереводов.ИсходныйЯзык = &ИсходныйЯзык";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Текст", ТекстыДляПоиска);
	Запрос.УстановитьПараметр("ЯзыкПеревода", ЯзыкПеревода);
	Запрос.УстановитьПараметр("ИсходныйЯзык", ИсходныйЯзык);
	
	ПереведенныеТексты = Новый Соответствие;
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		ПереведенныеТексты.Вставить(Выборка.Текст, Выборка.Перевод);
	КонецЦикла;
	
	Результат = Новый Соответствие;
	Для Каждого Текст Из Тексты Цикл
		Если ЗначениеЗаполнено(Текст) Тогда
			Результат.Вставить(Текст, ПереведенныеТексты[ИдентификаторыТекстов[Текст]]);
		Иначе
			Результат.Вставить(Текст, Текст);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура СохранитьПереводТекста(Текст, Перевод, ИсходныйЯзык, ЯзыкПеревода)
	
	Если Не ЗначениеЗаполнено(Текст) Или Не ЗначениеЗаполнено(Перевод) Или Не ЗначениеЗаполнено(ЯзыкПеревода) Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторТекста = ИдентификаторТекста(Текст);
	
	НаборЗаписей = РегистрыСведений.КэшПереводов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Текст.Установить(ИдентификаторТекста);
	НаборЗаписей.Отбор.ЯзыкПеревода.Установить(ЯзыкПеревода);
	НаборЗаписей.Отбор.ИсходныйЯзык.Установить(ИсходныйЯзык);
	Запись = НаборЗаписей.Добавить();
	Запись.Текст = ИдентификаторТекста;
	Запись.ИсходныйЯзык = ИсходныйЯзык;
	Запись.ЯзыкПеревода = ЯзыкПеревода;
	Запись.Перевод = СокрЛП(Перевод);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КэшПереводов");
	ЭлементБлокировки.УстановитьЗначение("Текст", ИдентификаторТекста);
	ЭлементБлокировки.УстановитьЗначение("ИсходныйЯзык", ИсходныйЯзык);
	ЭлементБлокировки.УстановитьЗначение("ЯзыкПеревода", ЯзыкПеревода);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция ИдентификаторТекста(Знач Текст)
	
	Возврат ОбщегоНазначения.СократитьСтрокуКонтрольнойСуммой(НРег(СокрЛП(Текст)), 50);
	
КонецФункции

Функция ПредставлениеЯзыка(КодЯзыка) Экспорт
	
	Если ПолучитьДопустимыеКодыЛокализации().Найти(КодЯзыка) <> Неопределено Тогда
		Возврат ПредставлениеКодаЛокализации(КодЯзыка);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция МодульСервисаПереводаТекста(Знач СервисПереводаТекста = Неопределено)
	
	Если СервисПереводаТекста = Неопределено Тогда
		СервисПереводаТекста = Константы.СервисПереводаТекста.Получить();
	КонецЕсли;
	
	Возврат МодулиСервисовПереводаТекста()[СервисПереводаТекста];
	
КонецФункции

// Имена модулей соответствуют именам значений перечисления СервисыПереводаТекста.
Функция МодулиСервисовПереводаТекста()
	
	Результат = Новый Соответствие;
	
	Для Каждого ОбъектМетаданных Из Метаданные.Перечисления.СервисыПереводаТекста.ЗначенияПеречисления Цикл
		ИмяМодуля = ОбъектМетаданных.Имя;
		Если Метаданные.ОбщиеМодули.Найти(ИмяМодуля) <> Неопределено Тогда
			Результат.Вставить(Перечисления.СервисыПереводаТекста[ОбъектМетаданных.Имя], ОбщегоНазначения.ОбщийМодуль(ИмяМодуля));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьНастройки()
	
	МодульСервисаПереводаТекста = МодульСервисаПереводаТекста();
	Если МодульСервисаПереводаТекста = Неопределено Или Не МодульСервисаПереводаТекста.НастройкаВыполнена() Тогда
		ВызватьИсключение НСтр("ru = 'Не указаны настройки сервиса перевода текстов.'");
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
//  Структура:
//   * ИнструкцияПоПодключению - Строка
//   * ПараметрыАвторизации - см. ПараметрыАвторизации
//
Функция НастройкиСервисаПереводаТекста(СервисПереводаТекста) Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("ИнструкцияПоПодключению");
	Настройки.Вставить("ПараметрыАвторизации", ПараметрыАвторизации());
	МодульСервисаПереводаТекста(СервисПереводаТекста).ПриОпределенииНастроек(Настройки);
	
	Возврат Настройки;
	
КонецФункции

// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Имя - Строка
//   * Представление - Строка
//   * Подсказка - Строка
//   * ОтображениеПодсказки - ОтображениеПодсказки
//
Функция ПараметрыАвторизации()
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Имя");
	Результат.Колонки.Добавить("Представление");
	Результат.Колонки.Добавить("Подсказка");
	Результат.Колонки.Добавить("ОтображениеПодсказки", Новый ОписаниеТипов("ОтображениеПодсказки"));
	
	Возврат Результат;
	
КонецФункции

Функция НастройкиАвторизации(Знач СервисПереводаТекста = Неопределено) Экспорт
	
	МодульСервисаПереводаТекста = МодульСервисаПереводаТекста(СервисПереводаТекста);
	Если МодульСервисаПереводаТекста = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат МодульСервисаПереводаТекста(СервисПереводаТекста).НастройкиАвторизации();
	
КонецФункции

Функция УбратьПараметрыИзТекста(Знач Текст)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		
		НайденныеПараметры = МодульУправлениеПечатью.НайтиПараметрыВТексте(Текст);
		ОбработанныеПараметры = Новый Массив;
		
		Счетчик = 0;
		Для Каждого Параметр Из НайденныеПараметры Цикл
			Если СтрНайти(Текст, Параметр) Тогда
				Счетчик = Счетчик + 1;
				Текст = СтрЗаменить(Текст, Параметр, ИдентификаторПараметра(Счетчик));
				ОбработанныеПараметры.Добавить(Параметр);
			КонецЕсли;
		КонецЦикла;
		
		Результат = Новый Структура;
		Результат.Вставить("Текст", Текст);
		Результат.Вставить("Параметры", ОбработанныеПараметры);
		
		Возврат Результат;
	
	КонецЕсли;
	
КонецФункции

Функция ВернутьПараметрыВТекст(Знач Текст, ОбработанныеПараметры)
	
	Для Счетчик = 1 По ОбработанныеПараметры.Количество() Цикл
		Текст = СтрЗаменить(Текст, ИдентификаторПараметра(Счетчик), "%" + XMLСтрока(Счетчик));
	КонецЦикла;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(Текст, ОбработанныеПараметры);
	
КонецФункции

// Последовательность символов, которая не должна меняться при переводе на любой язык.
Функция ИдентификаторПараметра(Номер)
	
	Возврат "{<" + XMLСтрока(Номер) + ">}"; 
	
КонецФункции

Функция РазделитьТекстНаЧасти(Знач Текст, Знач МаксимальныйРазмерЧастиТекста, Знач Разделители)
	
	Результат = Новый Массив;
	
	Разделитель = Лев(Разделители, 1);
	Разделители = Сред(Разделители, 2);
	
	Фрагменты = Новый Массив;
	ЧастиТекста = СтрРазделить(Текст, Разделитель, Истина);
	
	Для Индекс = 0 По ЧастиТекста.ВГраница() Цикл
		ЭтоПоследнийФрагмент = Индекс = ЧастиТекста.ВГраница();
		Фрагмент = ЧастиТекста[Индекс] + ?(ЭтоПоследнийФрагмент, "", Разделитель);
		РазмерФрагмента = СтрДлина(Фрагмент);
		
		Если РазмерФрагмента > МаксимальныйРазмерЧастиТекста Тогда
			Если Разделители <> "" Тогда
				ЧастиФрагмента = РазделитьТекстНаЧасти(Фрагмент, МаксимальныйРазмерЧастиТекста, Разделители);
			Иначе
				ВызватьИсключение НСтр("ru = 'Не удалось разделить текст на фрагменты.'");
			КонецЕсли;
			
			Для Каждого Фрагмент Из ЧастиФрагмента Цикл
				Фрагменты.Добавить(Фрагмент);
			КонецЦикла;
		Иначе
			Фрагменты.Добавить(Фрагмент);
		КонецЕсли;
	КонецЦикла;

	Порция = Новый Массив;
	РазмерПорции = 0;
	
	Для Индекс = 0 По Фрагменты.ВГраница() Цикл
		Фрагмент = Фрагменты[Индекс];
		РазмерФрагмента = СтрДлина(Фрагмент);
		ЭтоПоследнийФрагмент = Индекс = Фрагменты.ВГраница();
		
		Если РазмерПорции + РазмерФрагмента > МаксимальныйРазмерЧастиТекста Тогда
			Результат.Добавить(СтрСоединить(Порция, ""));
			Порция = Новый Массив;
			РазмерПорции = 0;
		КонецЕсли;

		Порция.Добавить(Фрагмент);
		РазмерПорции = РазмерПорции + РазмерФрагмента;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Порция) Тогда
		Результат.Добавить(СтрСоединить(Порция, ""));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(НСтр(
				"ru = 'Уничтожать персональные данные возможно только в главном узле распределенной информационной базы.'"));
			Возврат;
		КонецЕсли;

		// Заполняем значениями по умолчанию.
		Объект.Ответственный = Пользователи.ТекущийПользователь();
		Если Не Параметры.Свойство("Организация", Объект.Организация) Тогда
			ЗащитаПерсональныхДанных.ЗаполнитьРеквизитОрганизациейПоУмолчанию(Объект.Организация);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьСвойстваЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ЗаполнитьДеревоКатегорийДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанныхКлиент.ОбработкаОповещенияФормы(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПроверитьАктуальностьКатегорийДанных");
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Оповестить("УничтоженыПерсональныеДанные");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектПриИзменении(Элемент)
	
	ПриИзмененииСубъекта();

КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаОбработкуПерсональныхДанныхПриИзменении(Элемент)
	
	ОтветственныйЗаПДнПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСубъектаПриИзменении(Элемент)
	
	УстановитьСвойстваСубъекта();
	ПриИзмененииСубъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСубъектаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПровестиИЗакрыть(Команда)
	
	ПровестиДокумент(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровести(Команда)
	
	ПровестиДокумент(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКатегорииДанных(Команда)
	
	ЗаполнитьКатегорииДанных();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСвойстваЭлементов()
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ПричинаУничтожения.СписокВыбора.ЗагрузитьЗначения(
		ОбщегоНазначения.ВыгрузитьКолонку(Документы.АктОбУничтоженииПерсональныхДанных.ПричиныУничтожения(), "Значение"));
	
	Элементы.СпособУничтожения.СписокВыбора.ЗагрузитьЗначения(
		ОбщегоНазначения.ВыгрузитьКолонку(Документы.АктОбУничтоженииПерсональныхДанных.СпособыУничтожения(), "Значение"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТипСубъекта", "ТолькоПросмотр", Объект.Проведен);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Субъект", "ТолькоПросмотр", Объект.Проведен);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФИОСубъекта", "ТолькоПросмотр",
		Объект.Проведен);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КатегорииДанныхЗаполнитьКатегорииДанных",
		"Доступность", Не Объект.Проведен);

	УстановитьСвойстваТипаСубъекта();
	УстановитьСвойстваСубъекта();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваТипаСубъекта()
	
	ЗащитаПерсональныхДанных.УстановитьСвойстваТипаСубъекта(Элементы, Объект.Субъект, ТипСубъекта);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваСубъекта()
	
	Элементы.Субъект.ОграничениеТипа = ТипСубъекта;
	Объект.Субъект = ТипСубъекта.ПривестиЗначение(Объект.Субъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	АктОбъект = РеквизитФормыВЗначение("Объект");
	АктОбъект.ЗаполнитьДанныеОрганизации();
	ЗначениеВРеквизитФормы(АктОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ОтветственныйЗаПДнПриИзмененииНаСервере()
	
	Объект.ФИООтветственногоЗаОбработкуПДн = "";
	
	Если Не ЗначениеЗаполнено(Объект.ОтветственныйЗаОбработкуПерсональныхДанных) Тогда
		Возврат;
	КонецЕсли;

	АктОбъект = РеквизитФормыВЗначение("Объект");
	АктОбъект.ЗаполнитьДанныеОтветственногоЗаОбработку();
	ЗначениеВРеквизитФормы(АктОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСубъекта()
	
	Объект.КатегорииДанных.Очистить();
	Объект.ОбъектыСУничтожаемымиДанными.Очистить();
	
	Если ЗначениеЗаполнено(Объект.Субъект) Тогда
		
		ТолькоПросмотр = Истина;
		ДлительнаяОперация = ОбновитьСрокХраненияПерсональныхДанныхСубъекта(Объект.Субъект);
		
		Оповещение = Новый ОписаниеОповещения("ПриОкончанииОбновленияСрокаХранения", ЭтотОбъект);
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
		
	КонецЕсли;
	
	ЗаполнитьДанныеСубъекта();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСубъекта()
	
	АктОбъект = РеквизитФормыВЗначение("Объект");
	АктОбъект.ЗаполнитьДанныеСубъекта();
	ЗначениеВРеквизитФормы(АктОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКатегорииДанных()
	
	Если Не ЗначениеЗаполнено(Объект.Субъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ДлительнаяОперацияКатегорииПерсональныхДанныхСубъекта(Объект.Субъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ПриЗавершенииЗаполненияКатегорийДанных", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияКатегорииПерсональныхДанныхСубъекта(Субъект)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Документы.АктОбУничтоженииПерсональныхДанных.КатегорииУничтожаемыхДанныхСубъекта", Субъект);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииЗаполненияКатегорийДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;

	Для Каждого Сообщение Из Результат.Сообщения Цикл
		Сообщение.Сообщить();
	КонецЦикла;
	
	КатегорииДанныхСубъекта = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	УдалитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если КатегорииДанныхСубъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТабличныеЧасти(КатегорииДанныхСубъекта);
	ЗаполнитьДеревоКатегорийДанных();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныеЧасти(КатегорииДанныхСубъекта)
	
	АктОбъект = РеквизитФормыВЗначение("Объект");
	АктОбъект.ЗаполнитьТабличныеЧасти(КатегорииДанныхСубъекта);
	ЗначениеВРеквизитФормы(АктОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоКатегорийДанных()
	
	Если Объект.КатегорииДанных.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаКатегорий = Объект.КатегорииДанных.Выгрузить();
	
	ВсеКатегории = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ТаблицаКатегорий.ВыгрузитьКолонку("Категория"));
	
	ДеревоКатегорий = РеквизитФормыВЗначение("КатегорииПерсональныхДанных");
	ДеревоКатегорий.Строки.Очистить();
	
	Для Каждого Категория Из ВсеКатегории Цикл
		
		Если Не ЗначениеЗаполнено(Категория) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаКатегория = ДеревоКатегорий.Строки.Добавить();
		СтрокаКатегория.Данные = ЗащитаПерсональныхДанных.ПредставлениеКатегорииПерсональныхДанных(Категория);
		
		НайденныеСтроки = ТаблицаКатегорий.НайтиСтроки(Новый Структура("Категория", Категория));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			СтрокиТаблицыОбъектов = Объект.ОбъектыСУничтожаемымиДанными.НайтиСтроки(Новый Структура("ИмяОбъекта",
				НайденнаяСтрока.ИмяОбъекта));
			КоличествоОбъектов = ?(СтрокиТаблицыОбъектов.Количество() = 0, 0, СтрокиТаблицыОбъектов[0].КоличествоОбъектов);
			
			СтрокаОбъект = СтрокаКатегория.Строки.Добавить();
			ИмяОбъекта = Метаданные.НайтиПоПолномуИмени(НайденнаяСтрока.ИмяОбъекта).Синоним;
			СтрокаОбъект.Данные = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, %2'"),
				ИмяОбъекта, КоличествоОбъектов);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоКатегорий, "КатегорииПерсональныхДанных");
	
КонецПроцедуры

&НаСервере
Функция ОбновитьСрокХраненияПерсональныхДанныхСубъекта(Субъект)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения,
		"ЗащитаПерсональныхДанных.ОбновитьСрокХраненияПерсональныхДанныхСубъекта", Субъект);
		
КонецФункции

&НаКлиенте
Процедура ПриОкончанииОбновленияСрокаХранения(Результат, ДополнительныеПараметры) Экспорт
	
	ТолькоПросмотр = Ложь;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ЗаполнитьКатегорииДанных();
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СрокиХраненияПерсональныхДанных"));
	
КонецПроцедуры

#Область ПроведениеВФорме

&НаКлиенте
Процедура ПровестиДокумент(ЗакрыватьПослеЗаписи)
	
	ОчиститьСообщения();
	
	Если Объект.ПометкаУдаления Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Помеченный на удаление документ не может быть проведен.'"));
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ПровестиВДлительнойОперации();
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		Для Каждого Сообщение Из ДлительнаяОперация.Сообщения Цикл
			Сообщение.Сообщить();
		КонецЦикла;
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьПроведениеВДлительнойОперации", ЭтотОбъект,
		Новый Структура("ЗакрыватьПослеЗаписи", ЗакрыватьПослеЗаписи));
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

&НаСервере
Функция ПровестиВДлительнойОперации()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДанныеДокумента = Документы.АктОбУничтоженииПерсональныхДанных.СериализоватьОбъектВДвоичныеДанные(ДокументОбъект);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Проведение акта об уничтожении персональных данных'");
	
	Результат = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Документы.АктОбУничтоженииПерсональныхДанных.ВыполнитьПроведение", ДанныеДокумента, Истина);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьПроведениеВДлительнойОперации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		Для Каждого Сообщение Из Результат.Сообщения Цикл
			Сообщение.Сообщить();
		КонецЦикла;
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъектов(ОбщегоНазначенияКлиентСервер.МассивЗначений(
		Объект.Ссылка, Объект.Субъект));
	
	Модифицированность = Ложь;
	Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеПараметры, "ЗакрыватьПослеЗаписи", Ложь) Тогда
		Закрыть();
	Иначе
		ПроведениеПослеВыполненияДлительнойОперации(Результат);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПроведениеПослеВыполненияДлительнойОперации(Результат)
	
	ДокументОбъект = Документы.АктОбУничтоженииПерсональныхДанных.ДесериализоватьОбъектИзДвоичныхДанных(
		ПолучитьИзВременногоХранилища(Результат.АдресРезультата));
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	УстановитьСвойстваЭлементов();
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

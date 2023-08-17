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
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(Параметры.ПолноеИмяОбъекта);
	
	Если ОбщегоНазначения.ЭтоКонстанта(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'константе'");
	ИначеЕсли ОбщегоНазначения.ЭтоСправочник(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'справочнику'");
	ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'документу'");
	ИначеЕсли ИнтерфейсODataСлужебный.ЭтоНаборЗаписейПоследовательности(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'последовательности'");
	ИначеЕсли ОбщегоНазначения.ЭтоЖурналДокументов(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'журналу документов'");
	ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'перечислению'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланВидовХарактеристик(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану видов характеристик'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану счетов'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланВидовРасчета(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану видов расчета'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрСведений(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру сведений'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрНакопления(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру накопления'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрБухгалтерии(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру бухгалтерии'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрРасчета(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру расчета'");
	ИначеЕсли ИнтерфейсODataСлужебный.ЭтоНаборЗаписейПерерасчета(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'перерасчету'");
	ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'бизнес-процессу'");
	ИначеЕсли ОбщегоНазначения.ЭтоЗадача(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'задаче'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланОбмена(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану обмена'");
	КонецЕсли;
	
	Если Параметры.Добавление Тогда
		
		Элементы.ГруппаСтраницыШапка.ТекущаяСтраница = Элементы.ГруппаСтраницаШапкаДобавление;
		Элементы.ГруппаСтраницыПодвал.ТекущаяСтраница = Элементы.ГруппаСтраницаПодвалДобавление;
		Элементы.ДекорацияЗаголовокШапкаДобавление.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияЗаголовокШапкаДобавление.Заголовок,
			ПредставлениеТипаОбъекта,
			ОбъектМетаданных.Представление());
		
	Иначе
		
		Элементы.ГруппаСтраницыШапка.ТекущаяСтраница = Элементы.ГруппаСтраницаШапкаУдаление;
		Элементы.ГруппаСтраницыПодвал.ТекущаяСтраница = Элементы.ГруппаСтраницаПодвалУдаление;
		Элементы.ДекорацияЗаголовокШапкаУдаление.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияЗаголовокШапкаУдаление.Заголовок,
			ПредставлениеТипаОбъекта,
			ОбъектМетаданных.Представление());
		
	КонецЕсли;
	
	ЭтотОбъект.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЭтотОбъект.Заголовок, ОбъектМетаданных.Представление());
	
	// Заполнение дерева
	
	Дерево = Новый ДеревоЗначений();
	
	Дерево.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Класс", Новый ОписаниеТипов("Число", , Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)));
	Дерево.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
	
	ДобавитьКорневуюСтрокуДерева(Дерево, "Константа", НСтр("ru = 'Константы'"), 1, БиблиотекаКартинок.Константа);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Справочник", НСтр("ru = 'Справочники'"), 2, БиблиотекаКартинок.Справочник);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Документ", НСтр("ru = 'Документы'"), 3, БиблиотекаКартинок.Документ);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ЖурналДокументов", НСтр("ru = 'Журналы документов'"), 4, БиблиотекаКартинок.ЖурналДокументов);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Перечисление", НСтр("ru = 'Перечисление'"), 5, БиблиотекаКартинок.Перечисление);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланВидовХарактеристик", НСтр("ru = 'Планы видов характеристик'"), 6, БиблиотекаКартинок.ПланВидовХарактеристик);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланСчетов", НСтр("ru = 'Планы счетов'"), 7, БиблиотекаКартинок.ПланСчетов);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланВидовРасчета", НСтр("ru = 'Планы видов расчета'"), 8, БиблиотекаКартинок.ПланВидовРасчета);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрСведений", НСтр("ru = 'Регистры сведений'"), 9, БиблиотекаКартинок.РегистрСведений);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрНакопления", НСтр("ru = 'Регистры накопления'"), 10, БиблиотекаКартинок.РегистрНакопления);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрБухгалтерии", НСтр("ru = 'Регистры бухгалтерии'"), 11, БиблиотекаКартинок.РегистрБухгалтерии);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрРасчета", НСтр("ru = 'Регистры расчета'"), 12, БиблиотекаКартинок.РегистрРасчета);
	ДобавитьКорневуюСтрокуДерева(Дерево, "БизнесПроцесс", НСтр("ru = 'Бизнес-процессы'"), 13, БиблиотекаКартинок.БизнесПроцесс);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Задача", НСтр("ru = 'Задачи'"), 14, БиблиотекаКартинок.Задача);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланОбмена", НСтр("ru = 'Планы обмена'"), 15, БиблиотекаКартинок.ПланОбмена);
	
	Для Каждого Зависимость Из Параметры.ЗависимостиОбъекта Цикл
		ДобавитьВложеннуюСтрокуДерева(Дерево, ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(Зависимость));
	КонецЦикла;
	
	Дерево.Колонки.Удалить(Дерево.Колонки["ПолноеИмя"]);
	Дерево.Колонки.Удалить(Дерево.Колонки["Класс"]);
	
	УдаляемыеСтроки = Новый Массив();
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.Строки.Количество() = 0 Тогда
			УдаляемыеСтроки.Добавить(СтрокаДерева);
		Иначе
			СтрокаДерева.Строки.Сортировать("Представление");
		КонецЕсли;
	КонецЦикла;
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		Дерево.Строки.Удалить(УдаляемаяСтрока);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ОбъектыМетаданных");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьКорневуюСтрокуДерева(Дерево,Знач ПолноеИмя, Знач Представление, Знач Класс, Знач Картинка)
	
	НоваяСтрока = Дерево.Строки.Добавить();
	НоваяСтрока.ПолноеИмя = ПолноеИмя;
	НоваяСтрока.Представление = Представление;
	НоваяСтрока.Класс = Класс;
	НоваяСтрока.Картинка = Картинка;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВложеннуюСтрокуДерева(Дерево, Знач ОбъектМетаданных)
	
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	
	СтруктураИмени = СтрРазделить(ПолноеИмя, ".");
	КлассОбъекта = СтруктураИмени[0];
	
	СтрокаВладелец = Неопределено;
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.ПолноеИмя = КлассОбъекта Тогда
			СтрокаВладелец = СтрокаДерева;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаВладелец = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный объект метаданных: %1'"), ПолноеИмя);
	КонецЕсли;
	
	НоваяСтрока = СтрокаВладелец.Строки.Добавить();
	
	НоваяСтрока.Представление = ОбъектМетаданных.Представление();
	НоваяСтрока.Класс = СтрокаВладелец.Класс;
	НоваяСтрока.Картинка = СтрокаВладелец.Картинка;
	
КонецПроцедуры

#КонецОбласти
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
	
	УстановитьУсловноеОформление();
	ЗаполнитьТипыОбъектовВДеревеЗначений();	
	ЗаполнитьСпискиВыбора();
	
	АвтоматическиОчищатьНенужныеФайлы = АвтоматическаяОчисткаВключена();
	Элементы.Расписание.Заголовок     = ТекущееРасписание();
	
	Элементы.Расписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.НастроитьРасписание.Видимость = Ложь;
		Элементы.Расписание.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СтраницыИтогиУдаляемыеФайлы.ТекущаяСтраница = Элементы.СтраницаПодсчетИтоговУдаляемыеФайлы;
	РассчитатьСведенияОбУдаляемыхФайлах();
	РежимОчисткиФайлов = РаботаСФайламиСлужебный.РежимОчисткиФайлов();
	НастроитьРежимыОчисткиФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОжидатьЗавершениеРасчетаСведенийОбУдаляемыхФайлах();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" И Источник = "СпособХраненияФайлов" Тогда
		НастроитьРежимыОчисткиФайлов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОчисткиФайловПриИзменении(Элемент)
	РежимОчисткиФайловПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура РежимОчисткиФайловПриИзмененииСервер()
	РаботаСФайламиСлужебный.УстановитьРежимОчисткиФайлов(РежимОчисткиФайлов);
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиОчищатьНенужныеФайлыПриИзменении(Элемент)
	УстановитьПараметрРегламентногоЗаданияОчисткиНенужныхФайлов("Использование", АвтоматическиОчищатьНенужныеФайлы);
	Элементы.Расписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОбъектовМетаданных

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Если НЕ Копирование Тогда
		ПодключитьОбработчикОжидания("ДобавитьНастройкуОчисткиФайлов", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ДеревоОбъектовМетаданныхДействие Тогда
		ЗаполнитьСписокВыбора(Элементы.ДеревоОбъектовМетаданных.ТекущийЭлемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДеревоОбъектовМетаданныхПравилоОтбора" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуНастроек();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПравилоОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПодключитьОбработчикОжидания("ОткрытьФормуНастроек", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхДействиеПриИзменении(Элемент)
	
	ЗаписатьТекущиеНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПериодОчисткиПриИзменении(Элемент)
	
	ЗаписатьТекущиеНастройки();
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьНастройкиПоВладельцу(ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	НастройкаДляУдаления = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
	Если НастройкаДляУдаления <> Неопределено Тогда
		
		НастройкаДляУдаленияРодителя = НастройкаДляУдаления.ПолучитьРодителя();
		
		Если НастройкаДляУдаленияРодителя <> Неопределено И НастройкаДляУдаленияРодителя.ВозможностьДетализации Тогда
			
			ТекстВопроса = НСтр("ru = 'Удаление настройки приведет к прекращению очистки файлов
				|по заданным в ней правилам. Продолжить?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьНастройкуЗавершение", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение'"));
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Расширенная настройка очистки файлов не предусмотрена для этого объекта.'");
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПериодОчисткиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхДействиеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.НеОчищать"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбъемНенужныхФайлов(Команда)
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ОбъемНенужныхФайлов.ФормаОбъекта", ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеНеОчищать(Команда)
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.НеОчищать"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеОчиститьВерсии(Команда)
	
	Если Не МожноОчищатьВерсии() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьВерсии"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеОчиститьФайлы(Команда)
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлы"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеОчиститьФайлыИВерсии(Команда)
	
	Если Не МожноОчищатьВерсии() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлыИВерсии"));
	
КонецПроцедуры

&НаКлиенте
Функция МожноОчищатьВерсии()
	Если Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки.Количество() = 1 Тогда
		ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
		Если Не ТекущиеДанные.ЭтоФайл
			И ТекущиеДанные.ВладелецФайла <> Неопределено Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Для данного объекта версии файлов не хранятся.'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура СтаршеМесяца(Команда)
	УстановитьПериодОчисткиДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.СтаршеМесяца"));
КонецПроцедуры

&НаКлиенте
Процедура СтаршеШестиМесяцев(Команда)
	УстановитьПериодОчисткиДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.СтаршеШестиМесяцев"));
КонецПроцедуры

&НаКлиенте
Процедура СтаршеГода(Команда)
	УстановитьПериодОчисткиДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.СтаршеГода"));
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	Оповещение = Новый ОписаниеОповещения("ОчиститьЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Очистить ненужные файлы?
		|
		|Ненужные файлы будут безвозвратно удалены согласно заданным настройкам.
		|Рекомендуется предварительно сделать резервную копию информационной базы и сетевых томов хранения файлов (если они используются).'"), 
		РежимДиалогаВопрос.ОКОтмена);
КонецПроцедуры

&НаКлиенте
Процедура ОбъемУдаленныхФайлов(Команда)
	ОткрытьФорму("Справочник.ТомаХраненияФайлов.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСписку(Команда)
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФормыСписка = ИмяФормыСписка(ТекущиеДанные.ВладелецФайла);
	Если Не ПустаяСтрока(ИмяФормыСписка) Тогда
		ОткрытьФорму(ИмяФормыСписка(ТекущиеДанные.ВладелецФайла));
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьСведения(Команда)
	РассчитатьСведенияОбУдаляемыхФайлах();
	ОжидатьЗавершениеРасчетаСведенийОбУдаляемыхФайлах();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РассчитатьСведенияОбУдаляемыхФайлах()
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ОписаниеРасчетаИтогов = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, 
		"РаботаСФайламиСлужебный.СведенияОбОчищаемыхФайлах");
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершениеРасчетаСведенийОбУдаляемыхФайлах()
	Обработчик = Новый ОписаниеОповещения("ПриЗавершенииРасчетаСведенийОбУдаляемыхФайлах", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ОписаниеРасчетаИтогов, Обработчик, ПараметрыОжидания);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииРасчетаСведенийОбУдаляемыхФайлах(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если Результат.Статус = "Выполнено" Тогда
		Итоги = ПолучитьИзВременногоХранилища(Результат.АдресРезультата); // см. РаботаСФайламиСлужебный.СведенияОбОчищаемыхФайлах
		ОтобразитьИтоги(Итоги.ОбъемУдаляемыхФайлов, Итоги.ОбъемНенужныхФайлов);
	Иначе
		ОтобразитьИтоги(0, 0);
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось подсчитать объем удаляемых файлов:
			|%1'"),
			Результат.КраткоеПредставлениеОшибки);
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	Элементы.СтраницыИтогиУдаляемыеФайлы.ТекущаяСтраница = Элементы.СтраницаОтображениеИтоговУдаляемыеФайлы;
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьИтоги(ОбъемУдаляемыхФайлов, ОбъемНенужныхФайлов)
	Элементы.ОбъемУдаленныхФайлов.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Удаляемые файлы: %1 Мб'"),
		 Формат(ОбъемУдаляемыхФайлов, "ЧДЦ=2; ЧН=0;"));
	Элементы.ОбъемНенужныхФайлов.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Ненужные файлы: %1 Мб'"),
		 Формат(ОбъемНенужныхФайлов, "ЧДЦ=2; ЧН=0;"));
КонецПроцедуры

&НаСервере
Функция ПутьФормыВыбора(ВладелецФайла)
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВладелецФайла);
	Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаВыбора";
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьКомандыОчистить()
	
	ПодчиненныеСтраницы = Элементы.ОчисткаФайлов.ПодчиненныеЭлементы;
	Если ПустаяСтрока(ТекущееФоновоеЗадание) Тогда
		Элементы.ОчисткаФайлов.ТекущаяСтраница = ПодчиненныеСтраницы.Очистка;
	Иначе
		Элементы.ОчисткаФайлов.ТекущаяСтраница = ПодчиненныеСтраницы.СтатусФоновогоЗадания;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	
	СписокВыбораСВерсиями = Новый СписокЗначений;
	СписокВыбораСВерсиями.Добавить(Перечисления.ВариантыОчисткиФайлов.ОчиститьФайлыИВерсии);
	СписокВыбораСВерсиями.Добавить(Перечисления.ВариантыОчисткиФайлов.ОчиститьВерсии);
	СписокВыбораСВерсиями.Добавить(Перечисления.ВариантыОчисткиФайлов.НеОчищать);
	
	СписокВыбораБезВерсий = Новый СписокЗначений;
	СписокВыбораБезВерсий.Добавить(Перечисления.ВариантыОчисткиФайлов.ОчиститьФайлы);
	СписокВыбораБезВерсий.Добавить(Перечисления.ВариантыОчисткиФайлов.НеОчищать);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбора(Элемент)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Элемент.СписокВыбора.Очистить();
	
	Если СтрокаДерева.ЭтоФайл Тогда
		СписокВыбора = СписокВыбораСВерсиями;
	Иначе
		СписокВыбора = СписокВыбораБезВерсий;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		Элемент.СписокВыбора.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыОбъектовВДеревеЗначений()
	
	НастройкиОчистки = РегистрыСведений.НастройкиОчисткиФайлов.ТекущиеНастройкиОчистки();
	
	ДеревоОМ = РеквизитФормыВЗначение("ДеревоОбъектовМетаданных");
	ДеревоОМ.Строки.Очистить();
	
	МетаданныеСправочники = Метаданные.Справочники;
	
	ТаблицаТипов = Новый ТаблицаЗначений;
	ТаблицаТипов.Колонки.Добавить("ВладелецФайла");
	ТаблицаТипов.Колонки.Добавить("ТипВладельцаФайла");
	ТаблицаТипов.Колонки.Добавить("ИмяВладельцаФайла");
	ТаблицаТипов.Колонки.Добавить("ЭтоФайл", Новый ОписаниеТипов("Булево"));
	ТаблицаТипов.Колонки.Добавить("ВозможностьДетализации"  , Новый ОписаниеТипов("Булево"));
	МассивИсключений = РаботаСФайламиСлужебный.ОбъектыИсключенияПриОчисткеФайлов();
	Для Каждого Справочник Из МетаданныеСправочники Цикл
		
		Если Справочник.Реквизиты.Найти("ВладелецФайла") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТипыВладельцевФайлов = Справочник.Реквизиты.ВладелецФайла.Тип.Типы();
		Для Каждого ТипВладельца Из ТипыВладельцевФайлов Цикл
			
			МетаданныеВладельца = Метаданные.НайтиПоТипу(ТипВладельца);
			Если МассивИсключений.Найти(МетаданныеВладельца) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ТаблицаТипов.Добавить();
			НоваяСтрока.ВладелецФайла = ТипВладельца;
			НоваяСтрока.ТипВладельцаФайла = Справочник;
			НоваяСтрока.ИмяВладельцаФайла = МетаданныеВладельца.ПолноеИмя();
			Если Метаданные.Справочники.Содержит(МетаданныеВладельца)
				И МетаданныеВладельца.Иерархический Тогда
				
				НоваяСтрока.ВозможностьДетализации = Истина;
			КонецЕсли;
			
			Если Не СтрЗаканчиваетсяНа(Справочник.Имя, "ПрисоединенныеФайлы") Тогда
				НоваяСтрока.ЭтоФайл = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ВсеСправочники = Справочники.ТипВсеСсылки();
	
	ВсеДокументы = Документы.ТипВсеСсылки();
	УзелСправочники = Неопределено;
	УзелДокументы = Неопределено;
	УзелБизнесПроцессы = Неопределено;
	
	ВладельцыФайлов = Новый Массив;
	Для Каждого Тип Из ТаблицаТипов Цикл
		
		ТипВладельцаФайла = Тип.ТипВладельцаФайла; // ОбъектМетаданныхСправочник
		Если СтрНачинаетсяС(ТипВладельцаФайла.Имя, "Удалить")
			Или ВладельцыФайлов.Найти(Тип.ИмяВладельцаФайла) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВладельцыФайлов.Добавить(Тип.ИмяВладельцаФайла);
		
		Если ВсеСправочники.СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелСправочники = Неопределено Тогда
				УзелСправочники = ДеревоОМ.Строки.Добавить();
				УзелСправочники.СинонимНаименованияОбъекта = НСтр("ru = 'Справочники'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелСправочники.Строки.Добавить();
			ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ВладелецФайла);
			ДетализированныеНастройки = НастройкиОчистки.НайтиСтроки(Новый Структура(
				"ИдентификаторВладельца, ЭтоФайл",
				ИдентификаторОбъекта, Тип.ЭтоФайл));
			Если ДетализированныеНастройки.Количество() > 0 Тогда
				Для Каждого Настройка Из ДетализированныеНастройки Цикл
					ДетализированнаяНастройка = НоваяСтрокаТаблицы.Строки.Добавить();
					ДетализированнаяНастройка.ВладелецФайла = Настройка.ВладелецФайла;
					ДетализированнаяНастройка.ТипВладельцаФайла = Настройка.ТипВладельцаФайла;
					ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.ВладелецФайла;
					ДетализированнаяНастройка.Действие = Настройка.Действие;
					ДетализированнаяНастройка.ПравилоОтбора = "Изменить";
					ДетализированнаяНастройка.ПериодОчистки = Настройка.ПериодОчистки;
					ДетализированнаяНастройка.ЭтоФайл = Настройка.ЭтоФайл;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ВсеДокументы.СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелДокументы = НеОпределено Тогда
				УзелДокументы = ДеревоОМ.Строки.Добавить();
				УзелДокументы.СинонимНаименованияОбъекта = НСтр("ru = 'Документы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелДокументы.Строки.Добавить();
		ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелБизнесПроцессы = Неопределено Тогда
				УзелБизнесПроцессы = ДеревоОМ.Строки.Добавить();
				УзелБизнесПроцессы.СинонимНаименованияОбъекта = НСтр("ru = 'Бизнес-процессы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелБизнесПроцессы.Строки.Добавить();
		КонецЕсли;
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип.ВладелецФайла);
		НоваяСтрокаТаблицы.ВладелецФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ВладелецФайла);
		НоваяСтрокаТаблицы.ТипВладельцаФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ТипВладельцаФайла);
		НоваяСтрокаТаблицы.СинонимНаименованияОбъекта = МетаданныеОбъекта.Синоним;
		НоваяСтрокаТаблицы.ПравилоОтбора = "Изменить";
		НоваяСтрокаТаблицы.ЭтоФайл = Тип.ЭтоФайл;
		НоваяСтрокаТаблицы.ВозможностьДетализации = Тип.ВозможностьДетализации;
		
		НайденныеНастройки = НастройкиОчистки.НайтиСтроки(Новый Структура("ВладелецФайла, ЭтоФайл", НоваяСтрокаТаблицы.ВладелецФайла, Тип.ЭтоФайл));
		Если НайденныеНастройки.Количество() > 0 Тогда
			НоваяСтрокаТаблицы.Действие = НайденныеНастройки[0].Действие;
			НоваяСтрокаТаблицы.ПериодОчистки = НайденныеНастройки[0].ПериодОчистки;
		Иначе
			НоваяСтрокаТаблицы.Действие = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
			НоваяСтрокаТаблицы.ПериодОчистки = Перечисления.ПериодОчисткиФайлов.СтаршеГода;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УзелВерхнегоУровня Из ДеревоОМ.Строки Цикл
		УзелВерхнегоУровня.Строки.Сортировать("СинонимНаименованияОбъекта");
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоОМ, "ДеревоОбъектовМетаданных");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрРегламентногоЗаданияОчисткиНенужныхФайлов("Расписание", Расписание);
	Элементы.Расписание.Заголовок = Расписание;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодОчисткиДляВыбранныхОбъектов(ПериодОчистки)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьПериодОчисткиДляВыбранногоОбъекта(ПодчиненныйЭлементДерева, ПериодОчистки);
			КонецЦикла;
		Иначе
			УстановитьПериодОчисткиДляВыбранногоОбъекта(ЭлементДерева, ПериодОчистки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодОчисткиДляВыбранногоОбъекта(ВыбранныйОбъект, ПериодОчистки)
	
	ВыбранныйОбъект.ПериодОчистки = ПериодОчистки;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ВыбранныйОбъект.ВладелецФайла,
		ВыбранныйОбъект.ТипВладельцаФайла,
		ВыбранныйОбъект.Действие,
		ПериодОчистки,
		ВыбранныйОбъект.ЭтоФайл);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеДляВыбранныхОбъектов(Знач Действие)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьДействиеВыбранногоОбъектаСРекурсией(ПодчиненныйЭлементДерева, Действие);
			КонецЦикла;
		Иначе
			УстановитьДействиеВыбранногоОбъектаСРекурсией(ЭлементДерева, Действие);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеВыбранногоОбъектаСРекурсией(ВыбранныйОбъект, Знач Действие)
	
	УстановитьДействиеВыбранногоОбъекта(ВыбранныйОбъект, Действие);
	Для Каждого ДочернийОбъект Из ВыбранныйОбъект.ПолучитьЭлементы() Цикл
		УстановитьДействиеВыбранногоОбъекта(ДочернийОбъект, Действие);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеВыбранногоОбъекта(ВыбранныйОбъект, Знач Действие)
	
	Если Не ВыбранныйОбъект.ЭтоФайл Тогда
		Если Действие = ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьВерсии") Тогда
			Возврат;
		ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлыИВерсии") Тогда
			Действие = ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлы");
		КонецЕсли;
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлы") Тогда
		Действие = ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлыИВерсии");
	КонецЕсли;
	
	ВыбранныйОбъект.Действие = Действие;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ВыбранныйОбъект.ВладелецФайла,
		ВыбранныйОбъект.ТипВладельцаФайла,
		Действие,
		ВыбранныйОбъект.ПериодОчистки,
		ВыбранныйОбъект.ЭтоФайл);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекущиеНастройки()
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ТекущиеДанные.ВладелецФайла,
		ТекущиеДанные.ТипВладельцаФайла,
		ТекущиеДанные.Действие,
		ТекущиеДанные.ПериодОчистки,
		ТекущиеДанные.ЭтоФайл);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТекущиеНастройкиПоОбъекту(ВладелецФайла, ТипВладельцаФайла, Действие, ПериодОчистки, ЭтоФайл)
	
	Настройка                   = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
	Настройка.ВладелецФайла     = ВладелецФайла;
	Настройка.ТипВладельцаФайла = ТипВладельцаФайла;
	Настройка.Действие          = Действие;
	Настройка.ПериодОчистки     = ПериодОчистки;
	Настройка.ЭтоФайл           = ЭтоФайл;
	Настройка.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек()
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Если ТекущиеДанные.ПериодОчистки <> ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.ПоПравилу") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьСуществованиеНастройки(
		ТекущиеДанные.ВладелецФайла,
		ТекущиеДанные.ТипВладельцаФайла,
		ТекущиеДанные.Действие,
		ТекущиеДанные.ПериодОчистки,
		ТекущиеДанные.ЭтоФайл);
	
	Отбор = Новый Структура(
		"ВладелецФайла, ТипВладельцаФайла",
		ТекущиеДанные.ВладелецФайла,
		ТекущиеДанные.ТипВладельцаФайла);
	
	ТипЗначения = Тип("РегистрСведенийКлючЗаписи.НастройкиОчисткиФайлов");
	ПараметрыЗаписи = Новый Массив(1);
	ПараметрыЗаписи[0] = Отбор;
	
	КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Ключ", КлючЗаписи);
	
	ОткрытьФорму("РегистрСведений.НастройкиОчисткиФайлов.ФормаЗаписи", ПараметрыЗаписи, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания");
	ТекущееФоновоеЗадание = "";
	ИдентификаторФоновогоЗадания = "";
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания)
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверитьСуществованиеНастройки(ВладелецФайла, ТипВладельцаФайла, Действие, ПериодОчистки, ЭтоФайл)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиОчисткиФайлов.ВладелецФайла,
		|	НастройкиОчисткиФайлов.ТипВладельцаФайла
		|ИЗ
		|	РегистрСведений.НастройкиОчисткиФайлов КАК НастройкиОчисткиФайлов
		|ГДЕ
		|	НастройкиОчисткиФайлов.ВладелецФайла = &ВладелецФайла
		|	И НастройкиОчисткиФайлов.ТипВладельцаФайла = &ТипВладельцаФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	Запрос.УстановитьПараметр("ТипВладельцаФайла", ТипВладельцаФайла);
	
	КоличествоЗаписей = Запрос.Выполнить().Выгрузить().Количество();
	
	Если КоличествоЗаписей = 0 Тогда
		ЗаписатьТекущиеНастройкиПоОбъекту(ВладелецФайла, ТипВладельцаФайла, Действие, ПериодОчистки, ЭтоФайл);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) И Не ЗаданиеВыполнено(ИдентификаторФоновогоЗадания) Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
	Иначе
		ИдентификаторФоновогоЗадания = "";
		ТекущееФоновоеЗадание = "";
		УстановитьВидимостьКомандыОчистить();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторФоновогоЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
КонецФункции

&НаСервере
Процедура ЗапуститьРегламентноеЗадание()
	
	РегламентноеЗаданиеМетаданные = Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов;
	
	Отбор = Новый Структура;
	ИмяМетода = РегламентноеЗаданиеМетаданные.ИмяМетода;
	Отбор.Вставить("ИмяМетода", ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияОчистки = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияОчистки.Количество() > 0 Тогда
		ИдентификаторФоновогоЗадания = ФоновыеЗаданияОчистки[0].УникальныйИдентификатор;
	Иначе
		ПараметрыЗадания = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыЗадания.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Запуск вручную: %1'"), РегламентноеЗаданиеМетаданные.Синоним);
		РезультатЗадания = ДлительныеОперации.ВыполнитьВФоне(РегламентноеЗаданиеМетаданные.ИмяМетода, 
			Новый Структура("РучнойЗапуск", Истина), ПараметрыЗадания);
		Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
			ИдентификаторФоновогоЗадания = РезультатЗадания.ИдентификаторЗадания;
		КонецЕсли;
	КонецЕсли;
	
	ТекущееФоновоеЗадание = "Очистка";
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПараметрРегламентногоЗаданияОчисткиНенужныхФайлов(ИмяПараметра, ЗначениеПараметра)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Если СписокЗаданий.Количество() = 0 Тогда
		ПараметрыЗадания.Вставить(ИмяПараметра, ЗначениеПараметра);
		РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		ПараметрыЗадания = Новый Структура(ИмяПараметра, ЗначениеПараметра);
		Для Каждого Задание Из СписокЗаданий Цикл
			РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрРегламентногоЗаданияОчисткиНенужныхФайлов(ИмяПараметра, ЗначениеПоУмолчанию)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Для Каждого Задание Из СписокЗаданий Цикл
		Возврат Задание[ИмяПараметра];
	КонецЦикла;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

&НаСервере
Процедура ДобавитьНастройкиПоВладельцу(ВыбранноеЗначение)
	
	СтрокаВладелец = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
	
	ЗаписьВладельца = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(ЗаписьВладельца, СтрокаВладелец);
	ЗаписьВладельца.Записать();
	
	ЭлементВладелец = СтрокаВладелец.ПолучитьЭлементы();
	Для Каждого Настройка Из ВыбранноеЗначение Цикл
		НоваяЗапись = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
		НоваяЗапись.ВладелецФайла = Настройка;
		НоваяЗапись.ТипВладельцаФайла = СтрокаВладелец.ТипВладельцаФайла;
		НоваяЗапись.Действие = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
		НоваяЗапись.ПериодОчистки = Перечисления.ПериодОчисткиФайлов.СтаршеГода;
		НоваяЗапись.ЭтоФайл = СтрокаВладелец.ЭтоФайл;
		НоваяЗапись.Записать(Истина);

		ДетализированнаяНастройка = ЭлементВладелец.Добавить();
		ЗаполнитьЗначенияСвойств(ДетализированнаяНастройка, НоваяЗапись);
		ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка;
		ДетализированнаяНастройка.ПравилоОтбора = НСтр("ru = 'Изменить правило'");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеНастройки()
	
	НастройкаДляУдаления = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
	
	МенеджерЗаписи = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВладелецФайла = НастройкаДляУдаления.ВладелецФайла;
	МенеджерЗаписи.ТипВладельцаФайла = НастройкаДляУдаления.ТипВладельцаФайла;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.Удалить();
	
	РодительЭлементаНастроек = НастройкаДляУдаления.ПолучитьРодителя();
	Если РодительЭлементаНастроек <> Неопределено Тогда
		РодительЭлементаНастроек.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
	Иначе
		ДеревоОбъектовМетаданных.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекущееРасписание()
	Возврат ПараметрРегламентногоЗаданияОчисткиНенужныхФайлов("Расписание", Новый РасписаниеРегламентногоЗадания);
КонецФункции

&НаСервереБезКонтекста
Функция АвтоматическаяОчисткаВключена()
	Возврат ПараметрРегламентногоЗаданияОчисткиНенужныхФайлов("Использование", Ложь);
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданныхПравилоОтбора");
	
	ГруппаЭлементовОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.Действие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.ПериодОчистки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ПериодОчисткиФайлов.ПоПравилу;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "");
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданныхПериодОчистки");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.Действие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "");
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданныхДействие");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.Действие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОбъектовМетаданных.Действие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ВажнаяНадписьШрифт);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОчиститьДанныеНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНастройкуОчисткиФайлов()
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Если Не СтрокаДерева.ВозможностьДетализации Тогда
		ТекстСообщения = НСтр("ru = 'Расширенная настройка очистки файлов не предусмотрена для этого объекта.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормыВыбора = Новый Структура;
	
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Истина);
	
	ПараметрыФормыВыбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормыВыбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор элементов настроек'"));
	
	// Исключим из списка выбора уже существующие настройки.
	СуществующиеНастройки = СтрокаДерева.ПолучитьЭлементы();
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	ЭлементНастройки = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементНастройки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	СписокСуществующих = Новый Массив;
	Для Каждого Настройка Из СуществующиеНастройки Цикл
		СписокСуществующих.Добавить(Настройка.ВладелецФайла);
	КонецЦикла;
	ЭлементНастройки.ПравоеЗначение = СписокСуществующих;
	ЭлементНастройки.Использование = Истина;
	ЭлементНастройки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ПараметрыФормыВыбора.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	
	ОткрытьФорму(ПутьФормыВыбора(СтрокаДерева.ВладелецФайла), ПараметрыФормыВыбора, Элементы.ДеревоОбъектовМетаданных);

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ПрерватьФоновоеЗадание();
	ЗапуститьРегламентноеЗадание();
	УстановитьВидимостьКомандыОчистить();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
	
КонецПроцедуры

&НаСервере
Функция ИмяФормыСписка(Знач ВладелецФайла)
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВладелецФайла, Ложь);
	Возврат ?(ОбъектМетаданных <> Неопределено И ОбъектМетаданных <> Null, ОбъектМетаданных.ПолноеИмя() + ".ФормаСписка", "");
КонецФункции

&НаСервере
Процедура НастроитьРежимыОчисткиФайлов()
	
	ИспользоватьТома = РаботаСФайламиВТомахСлужебный.ХранитьФайлыВТомахНаДиске();
	Элементы.ОбъемУдаленныхФайлов.Видимость = ИспользоватьТома;
	Элементы.РежимОчисткиФайлов.Видимость = ИспользоватьТома;
	Элементы.АвтоматическиОчищатьНенужныеФайлы.Заголовок = ?(ИспользоватьТома, 
		НСтр("ru = 'Автоматически очищать:'"), НСтр("ru = 'Автоматически очищать ненужные файлы:'"));
	
КонецПроцедуры

#КонецОбласти
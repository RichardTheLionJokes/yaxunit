//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

Функция РезультатЗапроса(ОписаниеЗапроса, ДляКлиента) Экспорт
	
	Запрос = Запрос(ОписаниеЗапроса);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат ВыгрузитьРезультатЗапроса(РезультатЗапроса, ДляКлиента);
	
КонецФункции

// Результат пустой.
// 
// Параметры:
//  ОписаниеЗапроса - см. ЮТЗапросы.ОписаниеЗапроса
// 
// Возвращаемое значение:
//  Булево - Результат пустой
Функция РезультатПустой(Знач ОписаниеЗапроса) Экспорт
	
	Запрос = Запрос(ОписаниеЗапроса);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

// Возвращает значения реквизитов ссылки
// 
// Параметры:
//  Ссылка - ЛюбаяСсылка
//  ИменаРеквизитов - Строка
//  ОдинРеквизит - Булево
// 
// Возвращаемое значение:
//  - Структура Из Произвольный - Значения реквизитов ссылки при получении значений множества реквизитов
//  - Произвольный - Значение реквизита ссылки при получении значения одного реквизита
Функция ЗначенияРеквизитов(Ссылка, ИменаРеквизитов, ОдинРеквизит) Экспорт
	
	ИмяТаблицы = Ссылка.Метаданные().ПолноеИмя();
	
	ТекстЗапроса = СтрШаблон("ВЫБРАТЬ ПЕРВЫЕ 1 %1 ИЗ %2 ГДЕ Ссылка = &Ссылка", ИменаРеквизитов, ИмяТаблицы);
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ОдинРеквизит Тогда
		Возврат ЗначениеИзЗапроса(Запрос, 0);
	Иначе
		Возврат ЗначенияИзЗапроса(Запрос, ИменаРеквизитов);
	КонецЕсли;
	
КонецФункции

// Возвращяет записи результат запроса
// 
// Параметры:
//  ОписаниеЗапроса - см. ЮТЗапросы.ОписаниеЗапроса
//  ОднаЗапись - Булево - Вернуть первую запись
// 
// Возвращаемое значение:
//  Массив из Структура, Структура, Неопределено - Записи
Функция Записи(ОписаниеЗапроса, ОднаЗапись) Экспорт
	
	Если ОднаЗапись Тогда
		ОписаниеЗапроса.КоличествоЗаписей = 1;
	КонецЕсли;
	
	Запрос = Запрос(ОписаниеЗапроса);
	РезультатЗапроса = Запрос.Выполнить();
	
	Записи = ВыгрузитьРезультатЗапроса(РезультатЗапроса, Истина);
	
	Если НЕ ОднаЗапись Тогда
		Возврат Записи;
	ИначеЕсли Записи.Количество() Тогда
		Возврат Записи[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает значения реквизитов записи
// 
// Параметры:
//  ОписаниеЗапроса - см. ЮТЗапросы.ОписаниеЗапроса
//  ОдинРеквизит - Булево
// 
// Возвращаемое значение:
//  - Структура Из Произвольный - Значения множества реквизитов записи
//  - Произвольный - Значение одного реквизита записи
// 
Функция ЗначенияРеквизитовЗаписи(ОписаниеЗапроса, ОдинРеквизит) Экспорт
	
	Запись = Записи(ОписаниеЗапроса, Истина);
	
	Если ТипЗнч(Запись) <> Тип("Структура") Тогда
		Если ОдинРеквизит Тогда
			Возврат Неопределено;
		Иначе
			Реквизиты = СтрСоединить(ОписаниеЗапроса.ВыбираемыеПоля, ",");
			Возврат Новый Структура(Реквизиты);
		КонецЕсли;
	КонецЕсли;
	
	Если ОдинРеквизит Тогда
		Для каждого КлючЗнач Из Запись Цикл
			Возврат КлючЗнач.Значение;
		КонецЦикла;
	Иначе
		Возврат Запись;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Запрос.
// 
// Параметры:
//  ОписаниеЗапроса - см. ЮТЗапросы.ОписаниеЗапроса
// 
// Возвращаемое значение:
//  Запрос
Функция Запрос(ОписаниеЗапроса)
	
	Строки = Новый Массив();
	Строки.Добавить("ВЫБРАТЬ ");
	
	Если ОписаниеЗапроса.КоличествоЗаписей <> Неопределено Тогда
		Строки.Добавить("ПЕРВЫЕ " + ЮТОбщий.ЧислоВСтроку(ОписаниеЗапроса.КоличествоЗаписей));
	КонецЕсли;
	
	Если ОписаниеЗапроса.ВыбираемыеПоля.Количество() Тогда
		ВыбираемыеПоля = ОписаниеЗапроса.ВыбираемыеПоля;
	Иначе
		ВыбираемыеПоля = ЮТОбщий.ЗначениеВМассиве("1 КАК Поле");
	КонецЕсли;
	
	Строки.Добавить(СтрСоединить(ВыбираемыеПоля, "," + Символы.ПС));
	Строки.Добавить("ИЗ " + ОписаниеЗапроса.ИмяТаблицы);
	
	Если ОписаниеЗапроса.Условия.Количество() Тогда
		Строки.Добавить("ГДЕ (");
		Строки.Добавить(СтрСоединить(ОписаниеЗапроса.Условия, ") И (" + Символы.ПС));
		Строки.Добавить(")");
	КонецЕсли;
	
	Запрос = Новый Запрос(СтрСоединить(Строки, Символы.ПС));
	ЮТОбщий.ОбъединитьВСтруктуру(Запрос.Параметры, ОписаниеЗапроса.ЗначенияПараметров);
	
	Возврат Запрос;
	
КонецФункции

Функция ЗначенияИзЗапроса(Запрос, Реквизиты)
	
	Результат = Новый Структура(Реквизиты);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеИзЗапроса(Запрос, Реквизит)
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка[Реквизит];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ВыгрузитьРезультатЗапроса(РезультатЗапроса, ВМассив)
	
	Если НЕ ВМассив Тогда
		Возврат РезультатЗапроса.Выгрузить();
	Иначе
		Результат = Новый Массив();
	КонецЕсли;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Реквизиты = Новый Массив();
	ТабличныеЧасти = Новый Массив();
	
	ТипРезультатЗапроса = Тип("РезультатЗапроса");
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		
		Реквизиты.Добавить(Колонка.Имя);
		
		Если Колонка.ТипЗначения.СодержитТип(ТипРезультатЗапроса) Тогда
			ТабличныеЧасти.Добавить(Колонка.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыКонструктора = СтрСоединить(Реквизиты, ",");
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = Новый Структура(ПараметрыКонструктора);
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		
		Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
			Запись[ТабличнаяЧасть] = ВыгрузитьРезультатЗапроса(Выборка[ТабличнаяЧасть], ВМассив);
		КонецЦикла;
		
		Результат.Добавить(Запись);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

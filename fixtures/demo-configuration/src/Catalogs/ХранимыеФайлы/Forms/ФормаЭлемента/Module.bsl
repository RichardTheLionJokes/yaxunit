
//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
// 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() И НЕ Параметры.ЗначениеКопирования.Пустая() Тогда
		// при копировании очищаем имя файла, чтобы не возникало иллюзии, что содержимое файла тоже скопируется
		Объект.ИмяФайла = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

#Если НЕ МобильныйКлиент Тогда
	
	Элементы.СделатьИЗаписать.Видимость = Ложь;
	Элементы.СделатьВидеозаписьИЗаписать.Видимость = Ложь;
	Элементы.СделатьФотоснимокИЗаписать.Видимость = Ложь;
	Элементы.ДобавитьСохраненноеИзображение.Видимость = Ложь;
	Элементы.ДобавитьСохраненноеВидеоИЗаписать.Видимость = Ложь;
	Элементы.ДобавитьСохраненноеФотоИЗаписать.Видимость = Ложь;
	
#Иначе
	
	Если ТолькоПросмотр = Ложь Тогда
		Элементы.СделатьИЗаписать.Доступность = СредстваМультимедиа.ПоддерживаетсяАудиозапись();
		Элементы.СделатьВидеозаписьИЗаписать.Доступность = СредстваМультимедиа.ПоддерживаетсяВидеозапись();
		Элементы.СделатьФотоснимокИЗаписать.Доступность = СредстваМультимедиа.ПоддерживаетсяФотоснимок();
		Элементы.ДобавитьСохраненноеИзображение.Доступность = Истина;
		Элементы.ДобавитьСохраненноеВидеоИЗаписать.Доступность = Истина;
		Элементы.ДобавитьСохраненноеФотоИЗаписать.Доступность = Истина;
	Иначе
		Элементы.СделатьИЗаписать.Доступность = Ложь;
		Элементы.СделатьВидеозаписьИЗаписать.Доступность = Ложь;
		Элементы.СделатьФотоснимокИЗаписать.Доступность = Ложь;
		Элементы.ДобавитьСохраненноеИзображение.Доступность = Ложь;
		Элементы.ДобавитьСохраненноеВидеоИЗаписать.Доступность = Ложь;
		Элементы.ДобавитьСохраненноеФотоИЗаписать.Доступность = Ложь;
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.ИмяФайла = "" Тогда
		ПоказатьПредупреждение(, "Не выбран файл!");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлСДискаИЗаписать()
	НовыйОбъект = Объект.Ссылка.Пустая();
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайлСДискаИЗаписатьЗавершение", ЭтотОбъект, НовыйОбъект);
	НачатьПомещениеФайла(Оповещение, , "", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлСДискаИЗаписатьЗавершение(Результат, АдресВременногоХранилища, ВыбранноеИмя, НовыйОбъект) Экспорт
	Если Результат Тогда
		Объект.ИмяФайла = ВыбранноеИмя;

		Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
			Объект.Наименование = ПолучитьИмяФайла(ВыбранноеИмя);
		КонецЕсли;

		ПоместитьФайлОбъекта(АдресВременногоХранилища);
		Если НовыйОбъект Тогда
			ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
		Иначе
			ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайлов(ПомещенныеФайлы, ДопПараметры) Экспорт
		
	Перем ВыбранноеИмя;
	
	Если НЕ ПомещенныеФайлы = Неопределено Тогда
		
#Если МобильныйКлиент Тогда
		Файл = Новый Файл(ПомещенныеФайлы[0].Имя);
		ВыбранноеИмя = Файл.ПолучитьПредставлениеФайлаБиблиотекиМобильногоУстройства();
#КонецЕсли
		Объект.ИмяФайла = ВыбранноеИмя;
		ПоместитьФайлОбъекта(ПомещенныеФайлы[0].Хранение);
		
	Иначе
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Файлы не загружены'", "ru");
		Сообщение.Сообщить();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолучениеКаталога(Каталог, ДопПараметры) Экспорт
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Каталог = Каталог;
	ОпПослеПомещенияФайлов = Новый ОписаниеОповещения("ПослеПомещенияФайлов", ЭтотОбъект);
	НачатьПомещениеФайлов(ОпПослеПомещенияФайлов, , Диалог, Ложь);  
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлИСохранитьНаДиск()
	
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Данные не записаны'", "ru"));
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.ИмяФайла) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Имя не задано'", "ru"));
		Возврат;
	КонецЕсли;
	
	Адрес = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ДанныеФайла");
	ПолучитьФайл(Адрес, Объект.ИмяФайла, Истина);
КонецПроцедуры
	
#Если МобильныйКлиент Тогда
	
&НаКлиенте
Процедура ПоместитьМультимедиа(ДанныеМультимедиа)
	
	Если ДанныеМультимедиа <> Неопределено Тогда
		НовыйОбъект = Объект.Ссылка.Пустая();
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДанныеМультимедиа.ПолучитьДвоичныеДанные(), УникальныйИдентификатор);
		ТипСодержимого = ДанныеМультимедиа.ТипСодержимого;
		Номер = Найти(ТипСодержимого, "/");
		Если Номер > 0 Тогда
			ТипСодержимого = Лев(ТипСодержимого, Номер - 1);
		КонецЕсли;
		Объект.Наименование = ТипСодержимого + " " + Строка(ТекущаяДата());
		Объект.ИмяФайла = СтрЗаменить(Строка(ТекущаяДата()), ":", "_") + "." + ДанныеМультимедиа.РасширениеФайла;
		ПоместитьФайлОбъекта(АдресВременногоХранилища);
		Если НовыйОбъект Тогда
			ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
		Иначе
			ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура СделатьАудиозапись(Команда)
	
	ДанныеМультимедиа = СредстваМультимедиа.СделатьАудиозапись();
	ПоместитьМультимедиа(ДанныеМультимедиа);
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьВидеозапись(Команда)
	
	ДанныеМультимедиа = СредстваМультимедиа.СделатьВидеозапись();
	ПоместитьМультимедиа(ДанныеМультимедиа);
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьФотоснимок(Команда)
	
	ДанныеМультимедиа = СредстваМультимедиа.СделатьФотоснимок();
	ПоместитьМультимедиа(ДанныеМультимедиа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСохраненноеАудиоИЗаписать(Команда)
	
	ТипКаталога = ТипКаталогаБиблиотекиМобильногоУстройства.Аудио;
	ОпПослеПолучениеКаталога = Новый ОписаниеОповещения("ПослеПолучениеКаталога", ЭтотОбъект);
	НачатьПолучениеКаталогаБиблиотекиМобильногоУстройства(ОпПослеПолучениеКаталога, ТипКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСохраненноеВидеоИЗаписать(Команда)
	
	ТипКаталога = ТипКаталогаБиблиотекиМобильногоУстройства.Видео;
	ОпПослеПолучениеКаталога = Новый ОписаниеОповещения("ПослеПолучениеКаталога", ЭтотОбъект);
	НачатьПолучениеКаталогаБиблиотекиМобильногоУстройства(ОпПослеПолучениеКаталога, ТипКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСохраненноеФотоИЗаписать(Команда)
	
	ТипКаталога = ТипКаталогаБиблиотекиМобильногоУстройства.Картинки;
	ОпПослеПолучениеКаталога = Новый ОписаниеОповещения("ПослеПолучениеКаталога", ЭтотОбъект);
	НачатьПолучениеКаталогаБиблиотекиМобильногоУстройства(ОпПослеПолучениеКаталога, ТипКаталога);
	
КонецПроцедуры

#КонецЕсли

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ Команд криптографии 
// 

&НаКлиенте
Процедура Подписать(Команда)  
	// Получает на клиента
	// Подписывает
	// Помещает на сервер файл и подпись
	
	Оповещение = Новый ОписаниеОповещения(
		"ПодписатьПослеПодключенияРасширения",
		ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСКриптографией(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьПослеПодключенияРасширения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с криптографией'", "ru"));
		Возврат;
	КонецЕсли;
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		ПоказатьПредупреждение(, 
			НСтр("ru = 'Нет данных файла!!!'", "ru"),
			10);
		Возврат;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	ПараметрыФормы = Новый СписокЗначений;
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	Контекст = Новый Структура("Данные, ФайлДвоичныеДанные", Данные, ФайлДвоичныеДанные);
	ПолучитьСписокСертификатов(ПараметрыФормы, Ложь, "ПодписатьПослеПолученияСпискаСертификатов", Контекст);
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьПослеПолученияСпискаСертификатов(Результат, Контекст) Экспорт
	Если Результат = КодВозвратаДиалога.Отмена Тогда 
		Возврат;
	КонецЕсли;
	
	МенеджерКриптографии = Новый МенеджерКриптографии();
	
	Контекст2 = Новый Структура(
		"МенеджерКриптографии, ФайлДвоичныеДанные, Сертификат, Данные", 
		МенеджерКриптографии, Контекст.ФайлДвоичныеДанные, Результат, Контекст.Данные);
	
	Оповещение = Новый ОписаниеОповещения(
		"ПодписатьПослеСозданияМенеджераКриптографии",
		ЭтотОбъект, Контекст2);
	МенеджерКриптографии.НачатьИнициализацию(Оповещение, "", "", 75);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьПослеСозданияМенеджераКриптографии(МенеджерКриптографии, Контекст) Экспорт	
	
	// проверяем, что этим сертификатом файл еще не подписан
	
	Контекст.Вставить("ПодписиПолучены", Новый Массив());
	ПолучитьСледующиеПодписи(, Контекст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСледующиеПодписи(СертификатыПодписи, Контекст) Экспорт
	
	Если СертификатыПодписи  <> Неопределено Тогда
		Для Каждого СертификатПодписи Из СертификатыПодписи Цикл
			Если Контекст.Сертификат = СертификатПодписи Тогда 
				ПоказатьПредупреждение( ,
					НСтр("ru = 'Этим сертификатом файл уже подписан'", "ru"),
					10);
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
		Контекст.ПодписиПолучены.Добавить(Истина);
	КонецЕсли;
	
	Если Контекст.ПодписиПолучены.Количество() = Контекст.Данные.Количество() Тогда
			
		// подписываем
		Контекст2 = Новый Структура(
			"МенеджерКриптографии, ФайлДвоичныеДанные, Сертификат, Данные", 
			Контекст.МенеджерКриптографии, Контекст.ФайлДвоичныеДанные, Контекст.Сертификат, Контекст.Данные);
		ВводПароля(Контекст.МенеджерКриптографии, "ПодписатьЗавершение2", Контекст2);	
	
		Возврат;
		
	КонецЕсли;
	
	ТекущиеДанные = Контекст.Данные[Контекст.ПодписиПолучены.Количество()];			
	
	Оповещение = Новый ОписаниеОповещения(
		"ПолучитьСледующиеПодписи",
		ЭтотОбъект, Контекст);
	Контекст.МенеджерКриптографии.НачатьПолучениеСертификатовИзПодписи(
		Оповещение, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЗавершение2(Результат, Контекст) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Оповещение = Новый ОписаниеОповещения(
			"ПослеПодписиФайла",
			ЭтотОбъект, Контекст);
		Контекст.МенеджерКриптографии.НачатьПодписывание(
			Оповещение, Контекст.ФайлДвоичныеДанные, Контекст.Сертификат); 
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодписиФайла(ПодписанныеДанные, Контекст) Экспорт
	
	Контекст.Данные.Добавить(ПодписанныеДанные);
	// Сохраняем на сервере, использование пустой строки избавляет
	// от необходимости передавать обратно файл на сервер - он не менялся
	ЗаписатьДанныеФайла("", Контекст.Данные);
	ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодпись(Команда)
	// Подписи проверяем на сервере
	Если ПроверитьПодписьНаСервере() Тогда 
		Сообщение = НСтр("ru = 'Успешное завершение проверки ЭЦП'", "ru");
		ПоказатьПредупреждение( ,
			Сообщение, 
			3);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныйНаСервер(Команда)
	
	Оповещение = Новый ОписаниеОповещения(
		"ПоместитьЗашифрованныйПослеПодключенияРасширенияКриптографии",
		ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСКриптографией(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныйПослеПодключенияРасширенияКриптографии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с криптографией'", "ru"));
		Возврат;
	КонецЕсли;

	МенеджерКриптографии = Новый МенеджерКриптографии();

	Оповещение = Новый ОписаниеОповещения(
		"ПоместитьЗашифрованныйПослеИнициализацииМенеджера",
		ЭтотОбъект);
	МенеджерКриптографии.НачатьИнициализацию(Оповещение, "", "", 75);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПоместитьЗашифрованныйПослеИнициализацииМенеджера(МенеджерКриптографии, ДополнительныеПараметры) Экспорт
	
	Контекст = Новый Структура(
		"МенеджерКриптографии, НовыйОбъект, ИсходныеДанныеДляШифрования",
		МенеджерКриптографии, Объект.Ссылка.Пустая(), Неопределено);
		
	Оповещение = Новый ОписаниеОповещения(
		"ПоместитьЗашифрованныйПослеПодключенияРасширенияФайлов",
		ЭтотОбъект, Контекст);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);		
	
КонецПроцедуры	

&НаКлиенте
Процедура ПоместитьЗашифрованныйПослеПодключенияРасширенияФайлов(Результат, Контекст) Экспорт
	
	// выбор файла на диске, который нужно зашифровать и сохранить на сервере
	// если не подключено расширение работы с файлами, операция выполняется
	// неоптимально, увеличивается трафик с сервером и снижается защищенность
	Если Результат Тогда

		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		
		Оповещение = Новый ОписаниеОповещения(
			"ПоместитьЗашифрованныйПослеВыбораФайлаВДиалоге",
			ЭтотОбъект, Контекст);
		Диалог.Показать(Оповещение)
		
	Иначе
		Оповещение = Новый ОписаниеОповещения(
			"ПоместитьЗашифрованныйПослеПомещенияБезРасширения",
			ЭтотОбъект, Контекст);
		НачатьПомещениеФайла(Оповещение, , , Истина);
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныйПослеВыбораФайлаВДиалоге(ВыбранныеФайлы, Контекст) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст.ИсходныеДанныеДляШифрования = ВыбранныеФайлы[0];
	ПоместитьЗашифрованныеДанныеКонтекста(ВыбранныеФайлы[0], Контекст);	
		 
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныйПослеПомещенияБезРасширения(Результат, АдресФайлаДляШифрования, ВыбранноеИмя, Контекст) Экспорт
	// Копи-паст из ПоместитьЗашифрованныйНаСервер
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;	

	Контекст.ИсходныеДанныеДляШифрования = ПолучитьИзВременногоХранилища(АдресФайлаДляШифрования);
	ПоместитьЗашифрованныеДанныеКонтекста(ВыбранноеИмя, Контекст);
		 
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныеДанныеКонтекста(ВыбранныйФайл, Контекст) Экспорт
	
	ЧастиИмени = СтрРазделить(ВыбранныйФайл, ПолучитьРазделительПути());
	Если ЧастиИмени.Количество() <= 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.ИмяФайла = ЧастиИмени[ЧастиИмени.Количество() - 1];

	// Формируем список сертификатов, которыми можно будет файл расшифровать
	ПараметрыФормы = Новый СписокЗначений;
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.СертификатыПолучателей);
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	
	ПолучитьСписокСертификатов(ПараметрыФормы, Истина, "ПоместитьЗашифрованныйНаСерверЗавершение", Контекст);
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныйНаСерверЗавершение(Результат, Контекст) Экспорт
	Если Результат = КодВозвратаДиалога.Отмена Тогда 
		Возврат;
	КонецЕсли;

	Сертификаты = Результат;
	
	Если Сертификаты = Неопределено Или Сертификаты.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПоместитьЗашифрованныйПослеШифрования",
		ЭтотОбъект, Контекст);
	
	// шифруем для выбранных сертификатов
	Контекст.МенеджерКриптографии.НачатьШифрование(
		Оповещение, Контекст.ИсходныеДанныеДляШифрования, Сертификаты);
		
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныйПослеШифрования(ЗашифрованныйДвоичныеДанные, Контекст) Экспорт
		
	Объект.Зашифрован = Истина;

	// Сохраняем на сервере
	ЗаписатьДанныеФайла(ЗашифрованныйДвоичныеДанные, Новый Массив);
	Если Контекст.НовыйОбъект Тогда
		ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
	Иначе
		ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗашифроватьНаСервере(ДанныеСертификатов, ТекстОшибки)
	Сертификаты = Новый Массив();
	Для Каждого ДанныеСертификата Из ДанныеСертификатов Цикл
		Сертификаты.Добавить(Новый СертификатКриптографии(ДанныеСертификата));
	КонецЦикла;
	
	МенеджерКриптографии = Новый МенеджерКриптографии("", "", 75);
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Нет данных файла!!!'", "ru");
		Возврат Ложь;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	
	// шифруем
	ЗашифрованныйДвоичныеДанные = МенеджерКриптографии.Зашифровать(ФайлДвоичныеДанные, Сертификаты);

	// Сохраняем на сервере
	Объект.Зашифрован = Истина;
	ЗаписатьДанныеФайла(ЗашифрованныйДвоичныеДанные, Данные);
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура Зашифровать(Команда)
	
	Оповещение = Новый ОписаниеОповещения(
		"ЗашифроватьПослеПодключенияРасширения",
		ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСКриптографией(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьПослеПодключенияРасширения(Результат, ДополнительныеПараметры) Экспорт	
	
	Если Не Результат Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с Криптографией'", "ru"));
		Возврат;
	КонецЕсли;
	
	Если Объект.Зашифрован Тогда
		Сообщить(НСтр("ru = 'Файл уже зашифрован'", "ru"));
		Возврат;
	КонецЕсли;
	
	Если Объект.Подписан Тогда
		Сообщить(НСтр("ru = 'Файл подписан, операция шифрования запрещена'", "ru"));
		Возврат;
	КонецЕсли;
	
	// Формируем список сертификатов, которыми можно будет файл расшифровать
	ПараметрыФормы = Новый СписокЗначений;
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.СертификатыПолучателей);
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	ПолучитьСписокСертификатов(ПараметрыФормы, Истина, "ЗашифроватьЗавершение");
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьЗавершение(Результат, Контекст) Экспорт

	Если Результат = КодВозвратаДиалога.Отмена Тогда 
		Возврат;
	КонецЕсли;
	
	Сертификаты = Результат;
	
	Если Сертификаты = Неопределено Или Сертификаты.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	НовыйОбъект = Объект.Ссылка.Пустая();
	
	Контекст = Новый Структура(
		"НовыйОбъект, Сертификаты, ДанныеСертификатов",
		НовыйОбъект, Сертификаты, Новый Массив());
	ВыгрузитьСледующийСертификатДляШифрования(, Контекст);

КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьСледующийСертификатДляШифрования(ВыгруженныеДанные, Контекст) Экспорт
	
	Перем ТекстОшибки;
	
	Если ВыгруженныеДанные <> Неопределено Тогда
				
		Контекст.ДанныеСертификатов.Добавить(ВыгруженныеДанные);
		
	КонецЕсли;
	
	Если Контекст.ДанныеСертификатов.Количество() = Контекст.Сертификаты.Количество() Тогда
		
		Результат = ЗашифроватьНаСервере(Контекст.ДанныеСертификатов, ТекстОшибки);
	
		Если Не Результат Тогда
			Сообщить(ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		Если Контекст.НовыйОбъект Тогда
			ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
		Иначе
			ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ТекущийСертификат = Контекст.Сертификаты[Контекст.ДанныеСертификатов.Количество()];			
	
	Оповещение = Новый ОписаниеОповещения(
		"ВыгрузитьСледующийСертификатДляШифрования",
		ЭтотОбъект, Контекст);
	ТекущийСертификат.НачатьВыгрузку(Оповещение);

КонецПроцедуры	

&НаКлиенте
Процедура ПолучитьСРасшифровкой(Команда)
	// Получить на клиента
	// Расшифровать
	// Если двоичные данные, то передать на сервер
	// Поместить в файл
	Если Не ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда 
		Сообщение = НСтр("ru = 'Расшифровать возможно только файлы контрагентов'", "ru");
		Сообщить(Сообщение);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПолучитьСРасшифровкойПослеПодключенияРасширения",
		ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСКриптографией(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкойПослеПодключенияРасширения(Результат, ДополнительныеПараметры) Экспорт	
	
	Если Не Результат Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с криптографией'", "ru"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		Сообщить(НСтр("ru = 'Нет данных файла!!!'", "ru"));
		Возврат;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	
	МенеджерКриптографии = Новый МенеджерКриптографии();
	Контекст = Новый Структура(
		"МенеджерКриптографии, ФайлДвоичныеДанные",
		МенеджерКриптографии, ФайлДвоичныеДанные);
		
	Оповещение = Новый ОписаниеОповещения(
		"ПолучитьСРасшифровкойПослеИнициализацииМенеджера",
		ЭтотОбъект, Контекст);	
	МенеджерКриптографии.НачатьИнициализацию(Оповещение, "", "", 75); 
		
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкойПослеИнициализацииМенеджера(МенеджерКриптографии, Контекст) Экспорт
		
	ВводПароля(МенеджерКриптографии, "ПолучитьСРасшифровкойЗавершение", Контекст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкойЗавершение(Результат, Контекст) Экспорт
	Если Не Результат = КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПолучитьСРасшифровкойЗавершениеПодклчюениярасширенияФайлов",
		ЭтотОбъект, Контекст);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);		
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкойЗавершениеПодклчюениярасширенияФайлов(Результат, Контекст) Экспорт
	
	// сохранение расшифрованного в файловой системе клиента
	Если Результат Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.ПолноеИмяФайла = Объект.ИмяФайла;
		
		Оповещение = Новый ОписаниеОповещения(
			"ПолучитьСРасшифровкойПослеВыбораФайла",
			ЭтотОбъект, Контекст);
		Диалог.Показать(Оповещение);

	Иначе
		
		Оповещение = Новый ОписаниеОповещения(
			"ПолучитьСРасшифровкойПослеРасшифровкиБезрасширения",
			ЭтотОбъект, Контекст);
		Контекст.МенеджерКриптографии.НачатьРасшифровку(
			Оповещение, Контекст.ФайлДвоичныеДанные);	
			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкойПослеВыбораФайла(ВыбранныеФайлы, Контекст) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;		
	
	Оповещение = Новый ОписаниеОповещения(
			"ПолучитьСРасшифровкойПослеРасшифровкиСРасширением",
			ЭтотОбъект, Контекст);
	Контекст.МенеджерКриптографии.НачатьРасшифровку(
		Оповещение, Контекст.ФайлДвоичныеДанные, ВыбранныеФайлы[0]);

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкойПослеРасшифровкиБезрасширения(РасшифрованныйДвоичныеДанные, Контекст) Экспорт
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(РасшифрованныйДвоичныеДанные, УникальныйИдентификатор);
	ИмяФайла = Объект.ИмяФайла;
	ПолучитьФайл(АдресВоВременномХранилище, ИмяФайла, Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкойПослеРасшифровкиСРасширением(РасшифрованныйФайл, Контекст) Экспорт
	
	; // Файл расшифровался и записан в РасшифрованныйФайл 
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
// 

// процедура проверяет подписи
// - возращает Истина, если все подписи прошли проверку
&НаСервере
Функция ПроверитьПодписьНаСервере()
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		Сообщить(НСтр("ru = 'Нет данных файла!!!'", "ru"));
		Возврат Ложь;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	Если Данные.Количество() = 0 Тогда
		Сообщение = НСтр("ru = 'Файл никем не подписан'", "ru");
		Сообщить(Сообщение);
		Возврат Ложь;
	КонецЕсли;
	МенеджерКриптографии = Новый МенеджерКриптографии("", "", 75);
	Для Каждого ЭЦПДвоичныеДанные Из Данные Цикл
		МенеджерКриптографии.ПроверитьПодпись(ФайлДвоичныеДанные, ЭЦПДвоичныеДанные);
	КонецЦикла;
	Возврат Истина;
КонецФункции

// процедура сохраняет на сервере файл, и, при наличии, файлы ЭЦП
&НаСервере
Процедура ЗаписатьДанныеФайла(ФайлДвоичныеДанные, ЭЦПДвоичныеДанные)
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	// ДанныеФайла меняем, только если переданы двоичные ланные
	Если ТипЗнч(ФайлДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ЭлементСправочника.ДанныеФайла = Новый ХранилищеЗначения(ФайлДвоичныеДанные, Новый СжатиеДанных());
	КонецЕсли;

	ЭлементСправочника.Подпись = Новый ХранилищеЗначения(ЭЦПДвоичныеДанные, Новый СжатиеДанных());
	
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");     
	
КонецПроцедуры	

// процедура получает с сервера в виде массива двоичных данных файлы, первым идет
// файл, затем, при наличии, файлы ЭЦП
&НаСервере
Функция ПолучитьДанныеФайла()
	Данные = Новый Массив;
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ФайлДвоичныеДанные = ЭлементСправочника.ДанныеФайла.Получить();
	Если ТипЗнч(ФайлДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		Данные.Добавить(ФайлДвоичныеДанные);
		ФайлыЭЦП = ЭлементСправочника.Подпись.Получить();
		Если ТипЗнч(ФайлыЭЦП) = Тип("Массив") Тогда
			Для Каждого ФайлЭЦП Из ФайлыЭЦП Цикл
				Если ТипЗнч(ФайлЭЦП) = Тип("ДвоичныеДанные") Тогда
					Данные.Добавить(ФайлЭЦП);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Данные;
КонецФункции
	
// Формирование (интерактивное) списка сертификатов криптографии
// ПараметрыВыбора - список типов хранилищ, сертификаты которых могут участвовать в выборе
// МножественныйВыбор
&НаКлиенте
Процедура ПолучитьСписокСертификатов(ПараметрыВыбора, МножественныйВыбор, ИмяПроцедурыЗавершения, Контекст = Неопределено)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МножественныйВыбор", МножественныйВыбор);
	ФормаСпискаСертификатов = ПолучитьФорму("Справочник.ХранимыеФайлы.Форма.СписокСертификатов", ПараметрыФормы);
	ФормаСпискаСертификатов.Установка(ПараметрыВыбора);
	ФормаСпискаСертификатов.ОписаниеОповещенияОЗакрытии =
		Новый ОписаниеОповещения(ИмяПроцедурыЗавершения, ЭтотОбъект, Контекст);
	ФормаСпискаСертификатов.Открыть();
КонецПроцедуры

// Процедура извлекает данные объекта из временного хранилища, 
// производит модификацию элемента справочника и записывает его.
// 
// Параметры: 
//  АдресВременногоХранилища – Строка – адрес временного хранилища. 
// 
// Возвращаемое значение: 
//  Нет.
&НаСервере
Процедура ПоместитьФайлОбъекта(АдресВременногоХранилища)
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ЭлементСправочника.ДанныеФайла = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
	Файл = Новый Файл(ЭлементСправочника.ИмяФайла);
	ЭлементСправочника.ИмяФайла = Файл.Имя;
	ЭлементСправочника.Подпись = Новый ХранилищеЗначения(Неопределено, Новый СжатиеДанных());
	ЭлементСправочника.Зашифрован = Ложь;
	ЭлементСправочника.Подписан = Ложь;
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	УдалитьИзВременногоХранилища(АдресВременногоХранилища);
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");     
КонецПроцедуры

// интерактивный ввод пароля доступа к закрытому ключу сертификата криптографии
// возвращает введенный пароль в параметре вызова Пароль
// возращает Истина, если пароль введен
&НаКлиенте
Процедура ВводПароля(МенеджерСертификатов, ИмяПроцедурыЗавершения, Контекст = Неопределено)
	Вернуть = Ложь;
	ФормаПароля = ПолучитьФорму("Справочник.ХранимыеФайлы.Форма.ФормаПароля");
	ФормаПароля.МенеджерСертификатов = МенеджерСертификатов;
	ФормаПароля.ОписаниеОповещенияОЗакрытии =
		Новый ОписаниеОповещения(ИмяПроцедурыЗавершения, ЭтотОбъект, Контекст);
	ФормаПароля.Открыть();
КонецПроцедуры

// Функция возвращает имя файла из полного пути
// 
// Параметры: 
//  ПолныйПутьКФайлу – Строка – полный путь к файлу. 
// 
// Возвращаемое значение: 
//  Строка - имя файла.
&НаКлиенте
Функция ПолучитьИмяФайла(ПолныйПутьКФайлу)
	
	Если ПолныйПутьКФайлу = "" Тогда
		Возврат "";
	КонецЕсли;
	
	ПозицияРазделителя = СтрНайти(ПолныйПутьКФайлу, 
		ПолучитьРазделительПути(), 
		НаправлениеПоиска.СКонца);
		
	Если ПозицияРазделителя = 0 Тогда
		Возврат ПолныйПутьКФайлу;
	КонецЕсли;
	
	Возврат Прав(ПолныйПутьКФайлу, 
		СтрДлина(ПолныйПутьКФайлу) - ПозицияРазделителя);
	
	КонецФункции

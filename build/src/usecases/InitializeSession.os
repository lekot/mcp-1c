// Use case: initialize (contracts §3.1, MCP spec 2024-11-05 lifecycle).
// Вход — params (объект), выход — result для Response.
// Спецификация: server MUST ответить protocolVersion, capabilities, serverInfo;
// после ответа клиент MUST отправить notifications/initialized (мы не отвечаем на notification).

Функция ИнициализироватьСессию(Параметры) Экспорт
	Результат = Новый Соответствие;
	Результат.Вставить("protocolVersion", "2024-11-05");
	// Сервер с tools MUST объявить capabilities.tools; listChanged — опционально (spec server/tools).
	Возможности = Новый Соответствие;
	ИнструментыКап = Новый Соответствие;
	ИнструментыКап.Вставить("listChanged", Ложь);
	Возможности.Вставить("tools", ИнструментыКап);
	Результат.Вставить("capabilities", Возможности);
	ИнформацияОСервере = Новый Соответствие;
	ИнформацияОСервере.Вставить("name", "mcp-1c-onescript");
	ИнформацияОСервере.Вставить("version", "0.1.0");
	Результат.Вставить("serverInfo", ИнформацияОСервере);
	Возврат Результат;
КонецФункции

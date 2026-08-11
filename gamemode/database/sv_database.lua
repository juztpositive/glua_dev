Chainsaw.database = Chainsaw.database or {}
Chainsaw.database.info = Chainsaw.database.info or {} -- Информацию о таблицах буду брать отсюда

function Chainsaw.database.initialize(username, password, name) -- Chainsaw.database.initialize(juztpositive, juzztpositive, chainsaw_database) | Прост вход в таблицу
	print('[Chainsaw] Инициализация базы данных с MySQL')
	local cfg = {
		EnableMySQL = true,
		Host = "localhost",
		Username = username,
		Password = password,
		Database_name = name,
		Database_port = 3306,
		Preferred_module = "mysqloo",
		MultiStatements = false
	}

	local succ, err = pcall(MySQLite.initialize, cfg)
	if succ then
		Chainsaw.database.downloadInfo()
		print('[Chainsaw] Успешно закончена инициализация базы данных с MySQL')
	else
		print('[Chainsaw] Ошибка подключения к MySQL: '.. err)
	end
end

function Chainsaw.database.downloadInfo() -- Загружает информацию о таблицах и колоннах в этих таблицах, чтобы загрузить в Chainsaw.database.info для других +- автоматических функций
	timer.Simple(0.1,function ()
		MySQLite.query('SHOW TABLES', function(tables)
			if not tables then return end

			for k, v in pairs(tables) do
				local tablename = v["Tables_in_chainsaw_database"]
				if not tablename then continue end

				MySQLite.query('SHOW COLUMNS FROM '.. tablename, function(columns)
					local columnget = {}
					for _, column in pairs(columns) do
						if column["Field"] == 'id' then continue end

						columnget[#columnget + 1] = column["Field"]
					end

					columnstring = '( '.. table.concat(columnget, ", ") ..' )'

					Chainsaw.database.info[tablename] = {
						columns = columnstring,
						columnslist = columnget,
						-- В будущем информация мб будет добавляться хезе, пока так
					}
				end)
			end
		end)
	end)
end

function Chainsaw.database.create(title) -- Chainsaw.database.create("users") | Создает вот новую табличечку да
	print('[Chainsaw] Попытка создания новой таблицы базы данных')
	local success = function()
		print('[Chainsaw] Таблица '.. title ..' успешно создана')

		Chainsaw.database.downloadInfo()
	end
	local unsuccess = function(error, query)
		print('[Chainsaw] Ошибка! Таблица '.. title ..' не создана: ' .. error)
		return false
	end
	local sqlstring = 'CREATE TABLE IF NOT EXISTS '.. title .. '( id INT AUTO_INCREMENT PRIMARY KEY )'

	MySQLite.query(sqlstring, success, unsuccess)
end

function Chainsaw.database.addColumn(title, column, sqlstring) -- Chainsaw.database.addColumn("users", "steamid", 'VARCHAR(50) NOT NULL UNIQUE') | Ну тут короче добавляет в таблицу users колонну steamid с пометкой VARCHAR(50) NOT NULL UNIQUE
	print('[Chainsaw] Добавление новой колонны в таблицу: '.. title)
	local success = function()
		print('[Chainsaw] Успешно добавлена новая колонна '.. column ..' в таблицу '.. title)

		Chainsaw.database.downloadInfo()
	end
	local unsuccess = function()
		print('[Chainsaw] Ошибка! Колонна '.. column ..' не создана.')

		return false
	end

	MySQLite.query('ALTER TABLE '.. title ..' ADD '.. column ..' '.. sqlstring, success, unsuccess)
end

function Chainsaw.database.removeColumn(title, column) -- Chainsaw.database.removeColumn("users", "steamid") | Удаляет колонну кароче steamid в таблице users
	print('[Chainsaw] Удаление колонны из таблицы: '.. title)
	local success = function()
		print('[Chainsaw] Успешно удалена колонна '.. column ..' в таблице '.. title)

		Chainsaw.database.downloadInfo()
	end
	local unsuccess = function()
		print('[Chainsaw] Ошибка! Колонна '.. column ..' не удалена.')

		return false
	end

	MySQLite.query('ALTER TABLE '.. title ..' DROP '.. column, success, unsuccess)
end

function Chainsaw.database.insertData(title, values) -- Chainsaw.database.insertData("users", "( 'TEST' )")
	print('[Chainsaw] Вставка данных в таблице: '.. title)
	local success = function()
		print('[Chainsaw] Успешная вставка данных')
	end
	local unsuccess = function(error)
		print('[Chainsaw] Ошибка! Данные не вставились: '.. error)

		return false
	end

	MySQLite.query('INSERT INTO '.. title ..' '.. Chainsaw.database.info[title].columns ..' VALUES'.. values, success, unsuccess)
end

function Chainsaw.database.updateData(title, column, newVar, searchName, key) -- Chainsaw.database.updateData("users", "money", "200", "steamid", "'STEAM_0:1:219739348'") | newVar - новое значение; searchName - поиск по определенному значению; key - какое значение ищем
	print('[Chainsaw] Обновление данных в таблице: '.. title)
	local success = function()
		print('[Chainsaw] Успешно обновлена колонна '.. column ..' в таблице '.. title)
	end
	local unsuccess = function(error)
		print('[Chainsaw] Ошибка! Колонна '.. column ..' не обновлена: '.. error)

		return false
	end

	MySQLite.query('UPDATE '.. title ..' SET '.. column ..' = '.. newVar ..' WHERE '.. searchName ..' = '.. key, success, unsuccess)
end

function Chainsaw.database.getData(title, column, searchName, key) -- Chainsaw.database.getData("users", "money", "steamid", "'STEAM_0:1:219739348'") | searchName - поиск по определенному значению; column - из какой колонны мы хотим получить данные(* - если все); key - какое значение ищем
	print('[Chainsaw] Получение данных из таблицы: '.. title)
	local success = function(data)
		print('[Chainsaw] Успешно получена информация из колонны '.. column ..' в таблице '.. title)

		return data
	end
	local unsuccess = function(error)
		print('[Chainsaw] Ошибка! Информация из колонны '.. column ..' не получена: '.. error)

		return false
	end

	MySQLite.query('SELECT '.. column ..' FROM '.. title ..' WHERE '.. searchName ..' = '.. key, success, unsuccess)
end

function Chainsaw.database.deleteData(title, column, key) -- Chainsaw.database.deleteData("users", "money", "200")
	print('[Chainsaw] Удаление информации колонны из таблицы: '.. title ..', '.. column)
	local success = function()
		print('[Chainsaw] Успешно удалена информация колонны '.. column ..' в таблице '.. title)
	end
	local unsuccess = function(error)
		print('[Chainsaw] Ошибка! Информация колонны '.. column ..' не удалена: '.. error)

		return false
	end

	MySQLite.query('DELETE FROM '.. title ..' WHERE '.. column ..' = '.. key, success, unsuccess)
end

function Chainsaw.database.clearData(title) -- Chainsaw.database.clearData("users")
	print('[Chainsaw] Очистка таблицы ПОЛНОСТЬЮ: '.. title)
	local success = function()
		print('[Chainsaw] Успешно удалена ВСЯ информация в таблице '.. title)
	end
	local unsuccess = function(error)
		print('[Chainsaw] Ошибка! Информация таблицы '.. title ..' не удалена: '.. error)

		return false
	end

	MySQLite.query('DELETE FROM '.. title, success, unsuccess)
end

Chainsaw.database.initialize("juztpositive", "juzztpositive", "chainsaw_database")

concommand.Add("TestDatabase",function ()
	--Chainsaw.database.create("users")
	--Chainsaw.database.create("characters")
	--Chainsaw.database.addColumn("users", "money", 'INT UNSIGNED DEFAULT 1000')
	--Chainsaw.database.insertData("users", "( 'STEAM_0:1:219739348', DEFAULT )")
	--Chainsaw.database.updateData("users", "money", "200", "steamid", "'STEAM_0:1:219739348'")
	--Chainsaw.database.getData("users", "money", "steamid", "'STEAM_0:1:219739348'")
	--Chainsaw.database.deleteData("users", "money", "200")
	--Chainsaw.database.clearData("users")
end)

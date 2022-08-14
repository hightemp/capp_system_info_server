# capp_system_info_server

Сервер для получения данных о состоянии сервера. (В первую очередь своб. место на дисках)

## Описания структуры

## env

- SERVER_PORT=8080
- SERVER_HOST=0.0.0.0
- SECRET_KEY=secret - обязательный параметр для каждого запроса key=secret, является токеном
- DB_HOST=data/dbfile.db
- DB_DATABASE=
- DB_USER=
- DB_PASSWORD=

## cli параметры

* -p --port - сервер - порт
* -h --host - сервер - хост

## API

- `api/shell/run_command` - /bin/bash shell
- `api/current/*` - для получения текущих значений для
  - `/api/current/list_boot_time` - время загрузки сервра 
  - `/api/current/list_uptime` - время работы сервра 
  - `/api/current/list_pids` - 
  - `/api/current/list_users` - 
  - `/api/current/list_cpu_times` - 
  - `/api/current/list_per_cpu_times` - 
  - `/api/current/list_virtual_memory` - 
  - `/api/current/list_swap_memory` - 
  - `/api/current/list_disk_partitions` - список дисков с инф. о свободном месте
  - `/api/current/list_per_nic_net_io_counters` - 
  - `/api/current/list_net_if_stats` - 
  - `/api/current/list_per_disk_io_counters` - 
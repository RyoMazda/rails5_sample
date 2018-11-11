#!/bin/bash

# なんかエラー終了するとserver.pidが残ってて起動できないから消す
path=/rails/tmp/pids/server.pid
if [ -e ${path} ]; then
rm ${path}
fi

# static fileをcompile
rails assets:precompile
rails db:create  # 既にある場合は何もしないはず
rails db:migrate
rails s
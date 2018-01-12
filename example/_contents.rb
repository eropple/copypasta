literal 'myliteral.txt', data: 5

copy 'mycopy.txt'
copy 'mycopy2.txt', source: 'myrenamed.txt'
erb 'mytemplate.txt', locals: { a: 10, b: 100 }

download 'my-ip.txt', source: "https://v4.ifconfig.co/ip"

literal 'only-if.txt', data: "the int list had a 2 in it",
                       only_if: ->(params) { params[:list_of_ints].include?(2) }

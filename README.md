# Shompare
+ 比beyondCompare更方便的配置比较脚本，用于比较`a=b`形式的配置文件，会自动过滤注释（以#开头）内容并给出比对结论。依赖`dos2unix`

# 说明
+ 参数说明
  - `$1`:必传，需要比对的文件
  - `$2`:必传，用于对比的文件（标准文件）
  - `$3`:可选，如果前两个参数为jar包，此参数用于指定比对的jar包内的文件
  - `$4`:可选，设置模式，`q`表示安静模式，仅打印统计结论
+ 示例
+ 比对两个jar包的application-prod.properties
  - `./Shompare.sh A_cur.jar A_last.jar application-prod.properties`
+ 比对`A_cur.jar`包内application-prod.properties 和jar包外的`config/application-test.propertes`
  - `./Shompare.sh A_cur.jar config/application-test.properties application-prod.properties`
+ 比对A_cur.jar包内`quartz.properties`和jar包外quartz-test.properties
  - `./Shompare.sh A_cur.jar quartz-test.properties quartz.properties `

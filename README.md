# Shompare
+ 远超beyondCompare的配置比较程序。专门用于比较a=b形式的配置文件，会自动过滤注释（以#开头）内容并给出比对结论。

# 说明
+ 参数说明
  - `$1`:必传，需要比对的文件
  - `$2`:必传，用于对比对的文件（期望正确的文件）
  - `$3`:可选，如果前两个参数为压缩包（jar，zip），此参数用于指定比对的jar包内的文件
  - `$4`:可选，设置模式，`q`表示安静模式，经打印统计结论
+ 示例
+ 比对两个jar包的application-prod.properties
  - `./cmp_evo.sh A_cur.jar A_last.jar application-prod.properties`
+ 比对A_cur.jar包内application-prod.properties 和jar包外的application-test.propertes
  - `./cmp_evo.sh A_cur.jar config/application-test.properties application-prod.properties`
+ 比对A_cur.jar包内quartz.properties和jar包外quartz-test.properties
  - `./cmp_evo.sh A_cur.jar quartz-test.properties quartz.properties `

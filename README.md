# ConfigCompare
contrast the config files between two jar files or one jar file and one properties file

# 说明
+ 这是一个很小的shell脚本，没有采用规范的框架和模式，但以相对简洁的方式进行编码。对于yml文件需要先转换成properties文件。
+ 该脚本用于实现两个jar包内配置文件的比对（上次上线和本次上线的jar包文件）或者jar包内和jar包外配置文件的比对（本次上线jar包文件和测试环境测试通过的配置文件）
+ 比对两个jar包的application-prod.properties
  - `./cmp_evo.sh A_cur.jar A_last.jar application-prod.properties`
+ 比对A_cur.jar包内application-prod.properties 和jar包外的application-test.propertes
  - `./cmp_evo.sh A_cur.jar config/application-test.properties application-prod.properties`
+ 比对A_cur.jar包内quartz.properties和jar包外quartz-test.properties
  - `./cmp_evo.sh A_cur.jar quartz-test.properties quartz.properties `

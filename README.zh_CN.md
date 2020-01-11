# Shompare
+ 比beyondCompare更方便的配置比较脚本，用于比较`a=b`形式的配置文件，会自动过滤注释（以#开头）内容并给出比对结论。依赖`dos2unix`

# 需求
+ 项目中使用了配置文件，涉及超过100行配置，每次上线前准备配置文件花费大量时间还可能出错，需要工具自动化比对配置文件并给出报告供团队人员分析

## 详细设计
+ 比对配置文件，首先要确定比对的配置的类型为java项目的properties文件
+ 扩展需求
    - 支持yml配置文件，简单转换yml配置文件
    - 支持判断文件是否包含bom头信息
# 说明
+ 参数说明
  - `$1`:必传，需要比对的文件
  - `$2`:必传，用于对比的文件（标准文件）
  - `$3`:可选，如果前两个参数为jar包，此参数用于指定比对的jar包内的文件
  - `$4`:可选，设置模式，`q`表示安静模式，仅打印统计结论
+ 示例
  - 比对两个jar包的application-prod.properties
    + `./Shompare.sh A_cur.jar A_last.jar application-prod.properties`
  - 比对`A_cur.jar`包内application-prod.properties 和jar包外的`config/application-test.propertes`
    + `./Shompare.sh A_cur.jar config/application-test.properties application-prod.properties`
  - 比对A_cur.jar包内`quartz.properties`和jar包外quartz-test.properties
    + `./Shompare.sh A_cur.jar quartz-test.properties quartz.properties `
  - 输出
    ```
    不一致配置:server.port
            8649 <prod====test> 9015
    上线配置缺少配置:
            app.name.config=test
    上线多出配置:
            job.interval.seconds.taskNoticeCallbackRetry=100
    ==============================================
            累计检查配置 120项
            上线配置累计缺失 0 项
            上线配置累计不一致处 1 项 
            上线配置累计多出 1 项
    可从 /tmp/6866/rep.html 查看具体结果
    ```
   - 安静模式输出
     ```
     quiet mode...
     ==============================================
            累计检查配置 38项
            上线配置累计缺失 1 项
            上线配置累计不一致处 10 项 
            上线配置累计多出 0 项
     可从 /tmp/4447/rep.html 查看具体结果
     ```

## 安装

+ 下载
  - Unix
  ```
    curl -fLo ~/tools/Shompare --create-dirs \
    https://github.com/HoldenWang/Shompare/blob/master/Shompare.sh
  ```
  - Windows(PowerShell)
  ```
    md ~\tools\Shompare
    $uri = 'https://github.com/HoldenWang/Shompare/blob/master/Shompare.sh'
    (New-Object Net.WebClient).DownloadFile(
      $uri,
      $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        "~\tools\Shompare\Shompare.sh"
      )
    )
  ```

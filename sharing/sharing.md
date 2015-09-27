```meta
{
  "data-x":-3000
}
```

```embed-html
<p style="font-size:120px;color:#fff;text-align:center;">Promise</p>
```

```meta
{
  "data-x":0,
  "data-y":0,
  "data-rotate":0,
  "data-rotate-x":0,
  "data-rotate-y":0,
  "data-rotate-z":0,
  "data-scale":1,
  "data-z":0,
  "style":"",
  "class":""
}
```
`Promise` 对象用来进行延迟(deferred) 和异步(asynchronous ) 计算 [link](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise)
==============================

[http://erights.org/elib/distrib/pipeline.html](http://erights.org/elib/distrib/pipeline.html)


```meta
{
  "data-x":1000,
  "class":"slide-card",
  "style":"height:450px;"
}
```
My Understanding
=============================
```embed-html
  <div style="height:60px;" ></div>
```
`Promise 模式` : 是对 [异步] [计算] [过程] 的[抽象] 的设计模式

```embed-html
  <div style="height:40px;" ></div>
  <span style="height:60px;color:blue">程序 = 数据 + 算法</span>
```

```meta
{
  "data-x":2000,
  "data-y":1000,
  "data-scale":2,
  "data-rotate": 45,
  "class":"slide-card"
}
```
抽象
====================
```embed-html
  <div style="height:30px;" ></div>
```

是从众多的事物中抽取出共同的、本质性的特征，而舍弃其非本质的特征。[link](http://baike.baidu.com/subview/5293/11100825.htm)

```embed-html
  <div style="height:120px;" ></div>
```

`众多的事物` `抽取` `共同的` `本质性的` `特征` `舍弃` `其非本质`

```embed-html
  <div style="height:20px;" ></div>
```

```meta
{
  "data-x":2000,
  "data-y":1000,
  "data-scale":1.8,
  "data-rotate": 45
}
```

从某个业务逻辑角度，对一类事物进行简化、归纳其必要特征的行为

```meta
{
  "data-x":2400,
  "data-y":800,
  "data-scale":3.4,
  "data-rotate-x": 127,
  "data-rotate-y": 45,
  "data-transition-duration": 5000,
  "style": "height:500px;background-color:cadetblue;color:#fff;",
  "class": "slide-card"
}
```
Promise 本质的关键特征

```embed-html
  <div style="height:60px;" ></div>
```

一个 Promise 任何时候处于以下四种状态之一:
+ pending: 初始状态, 非 fulfilled 或 rejected.
+ fulfilled: 成功的操作.
+ rejected: 失败的操作.
+ settled: Promise已被fulfilled或rejected，且不是pending


```meta
{
  "data-x":1400,
  "data-y":3000,
  "style": "height:500px;background-color:#373B3C;color:#fff;",
  "class": "slide-card"
}
```
Promise 本质的关键特征

```embed-html
  <div style="height:60px;" ></div>
```

一个 Promise 任何时候处于以下四种状态之一:
+ pending: 初始状态, 非 fulfilled 或 rejected.
+ fulfilled: 成功的操作.
+ rejected: 失败的操作.
+ settled: Promise已被fulfilled或rejected，且不是pending


```meta
{
  "data-x":2000,
  "data-y":2000,
  "data-scale":8,
  "class": "slide-card"
}
```

```embed-html
<img height="380" src="https://github.com/alex-zhang/hecate/raw/master/hecate.png"/>
<img height="380" src="https://github.com/alex-zhang/Lamia-Lib/raw/master/project_logo.png"/>
```

Fork Me

[Lamia-Lib    https://github.com/alex-zhang/Lamia-Lib](https://github.com/alex-zhang/Lamia-Lib)

[hecate       https://github.com/alex-zhang/hecate](https://github.com/alex-zhang/hecate)


























```meta
{
  "data-y":-3000
}
```

```embed-html
<p style="font-size:120px;color:#fff;text-align:center;">Thanks</p>
```



```meta-end
```

```embed-js
console.log("Here Will Run After All!")
```
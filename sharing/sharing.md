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
  "data-transition-duration": 2000,
  "style":"",
  "class":""
}
```
Hey Hecate ~
============================

`Hecate` enables you to create beautiful interactive slides by using markdown.


>This presentation will show you examples of what it can do.


```bash
npm install hecate -g
```

[Fork Github](https://github.com/alex-zhang/hecate)

```embed-js
console.log("Here Will start")
```


```meta
{
  "data-x":1000,
  "class":"slide-card"
}
```
Tips:
==============================

1. Hit the next arrow...
-----------------------------

2. Run the cmd to get more tips.
----------------------------

```bash
hecate -h
```

3. We use markdown
----------------------------

[Back Home](#/impress_card_0)
----------------------------



```meta
{
  "data-x":2000,
  "data-y":1000,
  "data-scale":2,
  "data-rotate": 45,
  "class":"slide-card"
}
```
TRANSITION STYLES
============================

You can select from different transitions, like:

`data-x` `data-y` `data-rotate` `data-scale` `data-rotate-z`

`data-transition-duration`

U Can use  `embed-js` `embed-css` `embed-html` to insert Dom element in markdwon.
---------------------------------------------------------


```meta
{
  "data-x":2400,
  "data-y":800,
  "data-scale":3.4,
  "data-rotate-x": 127,
  "data-rotate-y": 45,
  "data-transition-duration": 5000,
  "style": "pointer-events: none",
  "class": "myOverview"
}
```
Overview
================================================

[https://github.com/alex-zhang/hecate](https://github.com/alex-zhang/hecate)
[https://www.npmjs.com/package/hecate](https://www.npmjs.com/package/hecate)

```embed-html
  <img src="https://raw.githubusercontent.com/alex-zhang/hecate/master/hecate.png"></img>
```

```embed-css
.myOverview {
  display: block;
  width: 1000px;
  height: 700px;
  padding: 40px 60px;
  border-radius: 30px;
  background-color:rgba(1,1,1,0.2);
  color: rgb(102, 102, 102);
}
```


```meta-end
```

```embed-js
console.log("Here Will Run After All!")
```
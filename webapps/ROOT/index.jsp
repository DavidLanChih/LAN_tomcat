<%@ page contentType="text/html" pageEncoding="UTF-8"%> 
<div id="app">
            {{ message }}
        </div>

        <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
        <script>
            new Vue({//一個網頁上可以放不只一個 Vue 實例，但不能在一個 Vue 實例中包另一個 Vue 實例（不可巢狀）
                el:'#app',//el: HTML '元素 id' 也可設定 class 來綁定 el 值由 # 改成 . 但若同時有數個同樣 class 名稱的元素，Vue 只能帶資料到同 class 名稱的第一個元素上。所以大部份都用 id 綁定
                data:{
                    message:'Hello World!'
                }
            });

            
        </script>
<body>
歡迎使用DavidLan的JSP平台~
</body>
<%
String content="100;URL=./LAN/open.jsp";     //跳轉頁面
response.setHeader("REFRESH",content); 
%>

<%
int x = 0;
   for (int i = 1; i <= 200; i++)
   { 
        for (int j = 2; j <= 4; j++)
        {   x = x + 1;
        }
   }
out.print(x);

int y=68;
for(int i=0; i<5; i++)
{  
    y=y-2; 
    out.print(y);
}
%>
<script>
var m="123";
var n="";
//n=m.reverse();
alert(m);
</script>
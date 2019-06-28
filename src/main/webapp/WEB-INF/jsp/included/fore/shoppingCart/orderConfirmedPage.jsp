<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<div>
    <script>
        $(function(){
            var oid = getUrlParms("oid");
            var data4Vue = {
                uri:'foreorderConfirmed'
            };
            //ViewModel
            var vue = new Vue({
                el: '#workingArea',
                data: data4Vue,
                mounted:function(){ //mounted　表示这个 Vue 对象加载成功了
                    this.load();
                },
                methods: {
                    load:function(){
                        var url =  this.uri+"?oid="+oid;
                        axios.get(url);
                    }
                }
            });

        })
    </script>
    <div class="orderFinishDiv">
        <div class="orderFinishTextDiv">
            <img src="img/site/orderFinish.png">
            <span>交易已经成功，卖家将收到您的货款。</span>
        </div>
    </div>
</div>
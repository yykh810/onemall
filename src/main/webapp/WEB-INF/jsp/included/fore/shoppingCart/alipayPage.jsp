<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<div >
    <script>
        $(function(){
            var oid = getUrlParms("oid");
            var total = getUrlParms("total");
            var data4Vue = {
                oid:'',
                total:''
            };
            //ViewModel
            var vue = new Vue({
                el: '#workingArea',
                data: data4Vue,
                mounted:function(){ //mounted　表示这个 Vue 对象加载成功了
                    this.oid = oid;
                    this.total = total;
                }
            });
        })
    </script>
    <div class="aliPayPageDiv">
        <div class="aliPayPageLogo">
            <img class="pull-left" src="img/site/simpleLogo.png">
            <div style="clear:both"></div>
        </div>

        <div>
            <span class="confirmMoneyText">扫一扫付款（元）</span>
            <span class="confirmMoney">
            ￥ {{total|formatMoneyFilter}} </span>

        </div>
        <div>
            <img class="aliPayImg" src="img/site/alipay2wei.png">
        </div>

        <div>
            <a :href="'payed?oid='+oid+'&total='+total"><button class="confirmPay">确认支付</button></a>
        </div>
    </div>
</div>
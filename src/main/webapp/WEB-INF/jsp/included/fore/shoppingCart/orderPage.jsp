<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<div>
    <script>
        $(function(){
            var data4Vue = {
                uri:'forebought',
                orders:[]
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
                        var url =  this.uri;
                        axios.get(url).then(function(response) {
                            vue.orders = response.data;
                            vue.$nextTick(function(){
                                linkDefaultActions();
                                orderPageRegisterListeners();
                            })
                        });
                    }
                }
            });
        })
        var deleteOrder = false;
        var deleteOrderid = 0;

        function orderPageRegisterListeners(){
            $("a[orderStatus]").click(function(){
                var orderStatus = $(this).attr("orderStatus");
                if('all'==orderStatus){
                    $("table[orderStatus]").show();
                }
                else{
                    $("table[orderStatus]").hide();
                    $("table[orderStatus="+orderStatus+"]").show();
                }

                $("div.orderType div").removeClass("selectedOrderType");
                $(this).parent("div").addClass("selectedOrderType");
            });

            $("a.deleteOrderLink").click(function(){
                deleteOrderid = $(this).attr("oid");
                deleteOrder = false;
                $("#deleteConfirmModal").modal("show");
            });

            $("button.deleteConfirmButton").click(function(){
                deleteOrder = true;
                $("#deleteConfirmModal").modal('hide');
            });

            $('#deleteConfirmModal').on('hidden.bs.modal', function (e) {
                if(deleteOrder){
                    var uri = "foredeleteOrder?oid="+deleteOrderid;
                    axios.put(uri).then(function(response){
                        if(0==response.data.code){
                            $("table.orderListItemTable[oid="+deleteOrderid+"]").hide();
                        }
                        else{
                            location.href="login";
                        }
                    });
                }
            })
        }
    </script>
    <div class="boughtDiv">
        <div class="orderType">
            <div class="selectedOrderType"><a orderStatus="all" href="#nowhere">所有订单</a></div>
            <div><a  orderStatus="waitPay" href="#nowhere">待付款</a></div>
            <div><a  orderStatus="waitDelivery" href="#nowhere">待发货</a></div>
            <div><a  orderStatus="waitConfirm" href="#nowhere">待收货</a></div>
            <div><a  orderStatus="waitReview" href="#nowhere" class="noRightborder">待评价</a></div>
            <div class="orderTypeLastOne"><a class="noRightborder"> </a></div>
        </div>
        <div style="clear:both"></div>
        <div class="orderListTitle">
            <table class="orderListTitleTable">
                <tr>
                    <td>宝贝</td>
                    <td width="100px">单价</td>
                    <td width="100px">数量</td>
                    <td width="120px">实付款</td>
                    <td width="100px">交易操作</td>
                </tr>
            </table>

        </div>

        <div class="orderListItem">
            <table v-for="o in orders" class="orderListItemTable" :orderStatus="o.status" :oid="o.id">
                <tr class="orderListItemFirstTR">
                    <td colspan="2">
                        <b>{{o.createDate | formatDateFilter('YYYY-MM-DD') }}</b>
                        <span>订单号: {{o.orderCode}}
                        </span>
                    </td>
                    <td  colspan="2"><img width="13px" src="img/site/orderItemTmall.png">天猫商场</td>
                    <td colspan="1">
                        <a class="wangwanglink" href="#nowhere">
                            <div class="orderItemWangWangGif"></div>
                        </a>

                    </td>
                    <td class="orderItemDeleteTD">
                        <a class="deleteOrderLink" :oid="o.id" href="#nowhere">
                            <span  class="orderListItemDelete glyphicon glyphicon-trash"></span>
                        </a>

                    </td>
                </tr>

                <tr class="orderItemProductInfoPartTR" v-for="oi,index in o.orderItems" >
                    <td class="orderItemProductInfoPartTD"><img width="80" height="80" :src="'img/productSingle_middle/'+oi.product.firstProductImage.id+'.jpg'"></td>
                    <td class="orderItemProductInfoPartTD">
                        <div class="orderListItemProductLinkOutDiv">
                            <a :href="'product?pid='+oi.product.id">{{oi.product.name}}</a>
                            <div class="orderListItemProductLinkInnerDiv">
                                <img src="img/site/creditcard.png" title="支持信用卡支付">
                                <img src="img/site/7day.png" title="消费者保障服务,承诺7天退货">
                                <img src="img/site/promise.png" title="消费者保障服务,承诺如实描述">
                            </div>
                        </div>
                    </td>
                    <td  class="orderItemProductInfoPartTD" width="100px">
                        <div class="orderListItemProductOriginalPrice">￥{{oi.product.originalPrice|formatMoneyFilter}}</div>
                        <div class="orderListItemProductPrice">￥{{oi.product.promotePrice|formatMoneyFilter}}</div>
                    </td>
                    <template v-if="index==0">
                        <td valign="top" :rowspan="o.orderItems.length" class="orderListItemNumberTD orderItemOrderInfoPartTD" width="100px">
                            <span class="orderListItemNumber">{{o.totalNumber}}</span>
                        </td>
                        <td valign="top"  :rowspan="o.orderItems.length"  width="120px" class="orderListItemProductRealPriceTD orderItemOrderInfoPartTD">
                            <div class="orderListItemProductRealPrice">￥ {{o.total|formatMoneyFilter}}</div>
                            <div class="orderListItemPriceWithTransport">(含运费：￥0.00)</div>
                        </td>
                        <td valign="top"  :rowspan="o.orderItems.length"  class="orderListItemButtonTD orderItemOrderInfoPartTD" width="100px">
                            <a v-if="o.status=='waitConfirm'" :href="'confirmPay?oid='+o.id">
                                <button class="orderListItemConfirm">确认收货</button>

                            </a>

                            <a v-if="o.status=='waitPay'" :href="'alipay?oid='+o.id+'&total='+o.total">
                                <button class="orderListItemConfirm">付款</button>
                            </a>

                            <div  v-if="o.status=='waitDelivery'">
                                <span>待发货</span>
                            </div>

                            <a v-if="o.status=='waitReview'" :href="'review?oid='+o.id">
                                <button  class="orderListItemReview">评价</button>
                            </a>
                        </td>
                    </template>
                </tr>
            </table>
        </div>
    </div>
</div>
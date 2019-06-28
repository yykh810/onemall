<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<div>
    <script>
        $(function(){
            var oid = getUrlParms("oid");
            var data4Vue = {
                uri:'forereview',
                orders:[],
                p:'',
                o:null,
                reviews:[],
                showReviews:false,
                content:''
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
                        axios.get(url).then(function(response) {
                            var result = response.data;
                            vue.p = result.data.p;
                            vue.o = result.data.o;
                            vue.reviews = result.data.reviews;
                            vue.$nextTick(function(){
                                linkDefaultActions();
                            })
                        });
                    },
                    doreview:function(){
                        var url =  "foredoreview?oid="+vue.o.id+"&pid="+vue.p.id+"&content="+vue.content;
                        axios.post(url).then(function(response) {
                            var result = response.data;
                            vue.showReviews = true;
                            vue.load();
                        });
                    }
                }
            });
        })
    </script>
    <div class="reviewDiv">
        <div class="reviewProductInfoDiv">
            <div class="reviewProductInfoImg"><img v-if="null!=p.firstProductImage" width="400px" height="400px" :src="'img/productSingle/'+p.firstProductImage.id+'.jpg'"></div>
            <div class="reviewProductInfoRightDiv">
                <div class="reviewProductInfoRightText">
                    {{p.name}}
                </div>
                <table class="reviewProductInfoTable">
                    <tr>
                        <td width="75px">价格:</td>
                        <td><span class="reviewProductInfoTablePrice">￥{{p.originalPrice|formatMoneyFilter}}</span> 元 </td>
                    </tr>
                    <tr>
                        <td>配送</td>
                        <td>快递:  0.00</td>
                    </tr>
                    <tr>
                        <td>月销量:</td>
                        <td><span class="reviewProductInfoTableSellNumber">{{p.saleCount}}</span> 件</td>
                    </tr>
                </table>

                <div class="reviewProductInfoRightBelowDiv">
                    <span class="reviewProductInfoRightBelowImg"><img1 src="img/site/reviewLight.png"></span>
                    <span v-if="null!=o" class="reviewProductInfoRightBelowText" >现在查看的是 您所购买商品的信息
    于 {{o.createDate | formatDateFilter('YYYY-MM-DD')}} 下单购买了此商品 </span>

                </div>
            </div>
            <div style="clear:both"></div>
        </div>
        <div class="reviewStasticsDiv">
            <div class="reviewStasticsLeft">
                <div class="reviewStasticsLeftTop"></div>
                <div class="reviewStasticsLeftContent">累计评价 <span class="reviewStasticsNumber"> {{p.reviewCount}}</span></div>
                <div class="reviewStasticsLeftFoot"></div>
            </div>
            <div class="reviewStasticsRight">
                <div class="reviewStasticsRightEmpty"></div>
                <div class="reviewStasticsFoot"></div>
            </div>
        </div>

        <div v-show="showReviews" class="reviewDivlistReviews">
            <div v-for="r in reviews" class="reviewDivlistReviewsEach">
                <div class="reviewDate">{{r.createDate| formatDateFilter}}</div>
                <div class="reviewContent">{{r.content}}</div>
                <div class="reviewUserInfo pull-right">{{r.user.anonymousName}}<span class="reviewUserInfoAnonymous">(匿名)</span></div>
            </div>
        </div>

        <div v-show="!showReviews" class="makeReviewDiv">
            <div class="makeReviewText">其他买家，需要你的建议哦！</div>
            <table class="makeReviewTable">
                <tr>
                    <td class="makeReviewTableFirstTD">评价商品</td>
                    <td><textarea v-model="content"></textarea></td>
                </tr>
            </table>
            <div class="makeReviewButtonDiv">
                <button @click="doreview" type="submit">提交评价</button>
            </div>
        </div>
    </div>
</div>
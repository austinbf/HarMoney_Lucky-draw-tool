import { window } from '@kit.ArkUI';

//每个列表项的约束接口
interface imageCount {
  url: string,
  count: number
}

@Entry
@Component
struct Index {
  onPageShow(): void {
    window.getLastWindow(getContext(this),(err,data)=>{
      if(!err.code) {
        data.setWindowLayoutFullScreen(true);
      }
    })
  }
  @State images: imageCount[] = [
    {url: 'app.media.bg_00', count: 0},
    {url: 'app.media.bg_01', count: 0},
    {url: 'app.media.bg_02', count: 0},
    {url: 'app.media.bg_03', count: 0},
    {url: 'app.media.bg_04', count: 0},
    {url: 'app.media.bg_05', count: 0}
  ];
  @State isGet:boolean=false//是否中大奖
  @State maskImgX:number=0;//水平缩放比
  @State maskImgY:number=0;//垂直缩放比
@State randomIndex: number=-1;
//层级
  @State maskZIndex:number=-1;
//遮罩透明度
@State maskOpacity:number=0
  @State arr:string[]=['pg','hw','xm']//奖池
  @State prize:string=''//默认没中奖

  build() {
    Stack(){
      //卡片界面
      Column() {
        Grid() {
          ForEach(this.images, (item: imageCount, index: number) => {
            GridItem() {
              Badge({
                count: item.count,
                position: BadgePosition.RightTop,
                style: {fontSize: 14}
              }) {
                Image($r(item.url)).width(80).height(100)
              }
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .width('100%')
        .height(300)
        .margin({top: 100})

        Button('立即抽卡')
          .width(200)
          .backgroundColor('#ed5b8c')
          .margin({top: 50})
          .onClick(()=>{
            this.maskOpacity=1
            this.maskZIndex=99
            this.maskImgX = 1
            this.maskImgY = 1
            this.randomIndex=Math.floor(Math.random()*6)})
      }
      .height('100%')
      .width('100%')
     // 抽卡遮罩
      Column({space:30}){
Text('获得生肖卡').fontColor('#f5ebcf').fontSize(25).fontWeight(FontWeight.Bold)
        Image($r(`app.media.img_0${this.randomIndex}`))
          .width(200)
          .scale({
            x: this.maskImgX,
            y: this.maskImgY
          })
          .animation({duration:300})

Button('开心收下')
  //在修改对象中的某一项的话要整个修改对象
  .onClick(()=>{
    this.images[this.randomIndex]={
      url:`app.media.img_0${this.randomIndex}`,
      count:this.images[this.randomIndex].count+1
    }
    this.maskOpacity=0
    this.maskZIndex=-1
    this.maskImgX = 0
    this.maskImgY = 0
    //判断是否集齐
    let flag:boolean=true;
    for(let item of this.images){
      if(item.count==0){flag=false;break;}
    }
    this.isGet=flag;
    if(flag){
      let randomIndex:number=Math.floor(Math.random()*4);
      this.prize = this.arr[randomIndex]
    }
  })
  .backgroundColor(Color.Transparent)
  .border({width:2,color:'#fff9e0'})
  .width(200)
  .height(50)
      }
      .opacity(this.maskOpacity)
      .zIndex(this.maskZIndex)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
      .backgroundColor('#ad000000')
      .animation({duration:200})
      if(this.isGet==true){
        Column({ space: 30 }){
          Text('恭喜获得手机一部')
            .fontColor('#f5ebcf')
            .fontSize(25)
            .fontWeight(700)
          Image($r(`app.media.${this.prize}`)).width(300)
          Button('再来一次')
            .onClick(()=>{
              this.isGet=false;
              this.prize = '';
              this.images = [
                { url: 'app.media.bg_00', count: 0 },
                { url: 'app.media.bg_01', count: 0 },
                { url: 'app.media.bg_02', count: 0 },
                { url: 'app.media.bg_03', count: 0 },
                { url: 'app.media.bg_04', count: 0 },
                { url: 'app.media.bg_05', count: 0 }
              ]
            })
            .width(200)
            .height(50)
            .backgroundColor(Color.Transparent)
            .border({ width: 2, color: '#fff9e0' })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
        .backgroundColor('#ad000000')
      }

    }

  }
}
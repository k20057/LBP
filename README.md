# LBP
練習2016年IC競賽題目
驗證沒問題
但沒合成
不確定對不對

要注意CIC給的testbench預設的End_CYCLE太大
modelsim會編譯錯誤
要少幾個0編譯才會正確
如果是vivado或quartus ii可能就沒問題
pre-simulation沒問題
但是合成後會不會就跑不了也不知道
使用的方法很簡單
設了8個counter硬湊做出來

install.packages("pbdZMQ")
library(pbdZMQ)
load("/Users/tuo/Desktop/独生子女养老/研究复现材料/stm_douban_13.RData")



library(dplyr)
library(showtextdb)
library(sysfonts)
library(showtext)
library(stm)
showtext_auto()
#输出词
summary(stm_13)
#输出词➕占比
plot(stm_13, type = "summary", n=6)
#输出主题共现矩阵
mod.out.corr <- topicCorr(stm_13)
plot(mod.out.corr)

#输出theta值
stm_13.datatable <- make.dt(stm_13,meta=data)
view(stm_13.datatable)
glimpse(stm_13.datatable)
# 找到每行 Topic1 到 Topic13 中的最大值列，并创建新的列 "top"
stm_13.datatable$top <- apply(stm_13.datatable[, paste0("Topic", 1:13)], 1, function(x) {
  which.max(x)
})

# 设置导出路径
output_path <- "/Users/tuo/Desktop/douban/stm_13_datatable.csv"

# 导出数据表为 CSV 文件
write.csv(stm_13.datatable, file = output_path, row.names = FALSE)

summary(effects_13)
# 估计主题相关性
topic_corr <- topicCorr(model = stm_13, method = "simple", cutoff = 0.01)
# 加载 igraph 包
library(igraph)

# 绘制主题相关性图
plot(topic_corr,
     vertex.color = "lightblue",
     vertex.label.color = "black",
     vertex.label.cex = 0.8,
     layout = layout.fruchterman.reingold)


#可视化
library(stminsights)
run_stminsights()

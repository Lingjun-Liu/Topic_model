
####1 数据####
# 读取 CSV 文件
data <- read.csv("/Users/tuo/Desktop/douban/stm_13_qinggan.csv")
####2 计算每个主题比例####

# 加载 dplyr 包
library(dplyr)

# 指定需要计算和的变量
variables <- c("length", "positive", "negative", "anger", "disgust", "fear", "sadness", "surprise", "good", "happy")

# 根据 top 变量分组，并计算每组的变量和
summary_result <- data %>%
  group_by(top) %>%
  summarise(across(all_of(variables), sum, na.rm = TRUE))

# 输出结果
print(summary_result)

# 将结果保存为 CSV 文件
write.csv(summary_result, file = "/Users/tuo/Desktop/douban/topic_qinggan.csv", row.names = FALSE)


#####2.1 7分类 分时间####
# 指定需要计算和的变量
variables <- c("length", "positive", "negative", "anger", "disgust", "fear", "sadness", "surprise", "good", "happy")

# 根据 top 变量分组，计算每组的变量和，并按照 year 排序
summary_result <- data %>%
  group_by(top, year) %>%  # 同时按 top 和 year 分组
  summarise(across(all_of(variables), sum, na.rm = TRUE)) %>%
  arrange(top, year)  # 按 top 和 year 排序

# 将结果保存为 CSV 文件
write.csv(summary_result, file = "/Users/tuo/Desktop/douban/topic_qinggan2.csv", row.names = FALSE)


####3 21分类####
# 读取 CSV 文件
dt <- read.csv("/Users/tuo/Desktop/douban/stm_13_qinggan21.csv")
# 指定需要计算和的变量
variables <- c("length", "positive", "negative","kuaile", "anxin", "zunjing", "zanyang", "xiangxin", 
               "xiai", "zhuyuan", "fennu", "beishang", "shiwang", "jiu", "si", "huang", 
               "kongju", "xiu", "fanmen", "zengwu", "bianze", "jidu", "huaiyi", "jingqi")

# 根据 top 变量分组，并计算每组的变量和
summary_result21 <- dt %>%
  group_by(top) %>%
  summarise(across(all_of(variables), sum, na.rm = TRUE)) %>%
  mutate(across(all_of(variables[-1]), ~ . / length * 100, .names = "{.col}_1"))

# 输出结果
print(summary_result21)


# 加载必要的包
library(dplyr)
library(ggplot2)
library(tidyr)

# 数据转换为长格式并排除指定变量
plot_data <- summary_result21 %>%
  select(top, ends_with("_1")) %>%
  select(-all_of(exclude_vars)) %>%
  pivot_longer(cols = -top, names_to = "emotion", values_to = "percentage") %>%
  mutate(emotion = gsub("_1", "", emotion))

# 绘制热力图
ggplot(plot_data, aes(x = factor(top), y = emotion, fill = percentage)) +
  geom_tile() +
  scale_fill_gradient(low = "orange", high = "darkred") +
  labs(x = "Top", y = "Emotion", fill = "Percentage (%)", title = "Emotion Distribution by Topic (Heatmap)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# 加载必要的包
library(dplyr)
library(ggplot2)
library(tidyr)

# 指定要排除的变量
exclude_vars <- c("positive_1", "negative_1")

# 数据转换为长格式并排除指定变量
plot_data <- summary_result21 %>%
  select(top, ends_with("_1")) %>%
  select(-all_of(exclude_vars)) %>%  # 排除不需要的变量
  pivot_longer(cols = -top, names_to = "emotion", values_to = "percentage") %>%
  mutate(emotion = gsub("_1", "", emotion))  # 去掉 "_1"

# 绘制带点的折线图
ggplot(plot_data, aes(x = factor(top), y = percentage, color = emotion, group = emotion)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(x = "Top", y = "Percentage (%)", title = "Emotion Distribution by Topic (Line Chart with Points)") +
  theme_minimal() +
  theme(legend.position = "right", legend.title = element_blank(), axis.text.x = element_text(angle = 45, hjust = 1))

####只画前六个情绪###
# 加载必要的包
library(dplyr)
library(ggplot2)
library(tidyr)
library(showtextdb)
library(sysfonts)
library(showtext)
showtext_auto()
# 选择要绘制的变量
selected_vars <- c("beishang_1", "bianze_1", "fanmen_1", "kuaile_1", "xiai_1", "zanyang_1")

# 数据转换为长格式并选择指定的变量
plot_data <- summary_result21 %>%
  select(top, all_of(selected_vars)) %>%
  pivot_longer(cols = -top, names_to = "emotion", values_to = "percentage") %>%
  mutate(emotion = factor(emotion, levels = selected_vars, 
                          labels = c("悲伤", "贬责", "烦闷", "快乐", "喜爱", "赞扬"))) # 自定义图例标签

# 绘制带点的折线图（黑白色调，不同点形状区分）
ggplot(plot_data, aes(x = factor(top), y = percentage, linetype = emotion, shape = emotion, group = emotion)) +
  geom_line(size = 0.8, color = "black") + # 黑色线条
  geom_point(size = 3, color = "black") + # 黑色点
  scale_shape_manual(values = c(16, 17, 18, 19, 15, 8)) + # 为每个情绪变量指定不同的点样式
  labs(x = "主题类别", y = "占全部文本的百分比 (%)") +
  theme_minimal() +
  theme(legend.position = "right", legend.title = element_blank(), 
        axis.text.x = element_text(angle = 45, hjust = 1))
# 绘制带点的折线图（黑白色调，不同点形状区分）
ggplot(plot_data, aes(x = factor(top), y = percentage, linetype = emotion, shape = emotion, group = emotion)) +
  geom_line(size = 0.8, color = "black") + # 黑色线条
  geom_point(size = 3, color = "black") + # 黑色点
  scale_shape_manual(values = c(16, 17, 18, 19, 15, 8)) + # 不同点样式
  labs(x = "主题类别", y = "占全部文本的百分比 (%)") +
  theme_minimal(base_size = 14) + # 增加基础字号
  theme(
    legend.position = "right",
    legend.title = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_blank(), # 去掉主要网格线
    panel.grid.minor = element_blank(), # 去掉次要网格线
    panel.background = element_blank(), # 设置纯白背景
    axis.line.x = element_line(color = "black"), # 添加x轴线
    axis.line.y = element_line(color = "black")  # 添加y轴线
  )

# Topic_model

# 主题模型技术报告

Topic Models 自诞生以来，始终在**概率统计框架**与**语义表示方法**的双重驱动下演进。大致经历了三个阶段：从最初基于混合分布假设的经典贝叶斯方法，到能够整合多维元信息的结构化模型，再到近年来依赖神经网络的范式。其理论与技术的革新反映了自然语言处理与社会科学分析文本数据的持续探索和需求。

## 我使用topic models做过的分析。

**Beyond Economic Support: Responsibility, Emotion, and Institutions in the Elder-Care Practices of China’s Only-Child Generation**

**Abstract**: As the parents of China’s only-child generation enter old age, the traditional family-based model of elder care faces unprecedented challenges. Drawing on 400,000 online discussion posts, this study employs a Structural Topic Model (STM) and qualitative content analysis to examine the lived experiences and moral reasoning behind only children’s elder-care practices. The findings reveal that the responsibility of elder care has shifted from a static intergenerational duty to a dynamic “network of responsibility” embedded in marital choices, career trajectories, and emotional negotiations. Within this network, family roles and affective ties are constantly reshaped, and filial ethics are undergoing transformation: responsibility moves from unilateral obligation to negotiated commitment; emotional expression becomes more open; and caregiving increasingly depends on social and institutional support. This emergent form of negotiated filiality reflects the adaptive reconfiguration of traditional family ethics in an individualized society. The study highlights how demographic transitions are restructuring intergenerational responsibilities and offers a new lens for understanding China’s ongoing social transformation.
**Keywords**: eldercare of only-children; filial ethics; emotional labor; computational sociology

[研究的复现材料和代码](./Replication%20Materials)也已经上传，因为数据清洗的时候数据量比较大用R太慢了，所以数据清洗in Python，模型拟合in R，数据在不同的平台转换所以代码本比较多，可以根据以下分析流程对照看每个文件。
![分析流程图](./Replication%20Materials/readme_cn:en.png)




---
接下来的部分主要是
## 1. LDA：概率主题模型的奠基之作

2003 年 Blei 等人提出的 **Latent Dirichlet Allocation（LDA）** 标志着主题建模体系的真正成型。

- 生成机制上，LDA 设定了两级贝叶斯混合结构：
  - 为每篇文档采样主题分布：  
    $\theta_d \sim \mathrm{Dir}(\alpha)$
  - 对每个主题采样词语分布：  
    $\phi_k \sim \mathrm{Dir}(\beta)$
  - 每个词的主题指派 $z_{dn}$ 和词项 $w_{dn}$ 分别来自 $\theta_d$ 与 $\phi_{z_{dn}}$ 的多项分布抽样。

- 特点：
  - 以稀疏狄利克雷先验确保推断可行；
  - 可通过 Gibbs 采样或变分推断等数值方法高效求解。

- 局限：
  1. 主题之间相互独立；
  2. 文档生成过程不受任何外生元信息影响。

---

## 2. 从局限到扩展：CTM、DMR 与 SAGE

为突破 LDA 的局限，研究者提出多种扩展模型：

### (1) Correlated Topic Model（CTM）

- 用 Logistic Normal 分布代替 Dirichlet：
  - 显式建模主题间的相关结构；
  - 丰富主题空间几何形态；
  - 为引入回归结构奠定正态性基础。

### (2) Dirichlet–Multinomial Regression（DMR）

- 融合文档元信息（如时间、作者、地理位置）：
  - 先验参数建模为：  
    $\alpha_d = \exp{(X_d \beta)}$
  - $\theta_d$ 成为由元信息调控的变分族。

### (3) Sparse Additive Generative Model（SAGE）

- 将“主题-词”概率迁移到对数空间：
  - $\log{\phi_{kw}} = \mu_w + \delta_{kw} W^{(c)}$
  - 词项的全局基准概率 $\mu_w$ 与主题局部偏差 $\delta_{kw}$ 得以分离；
  - 捕捉主题在不同语域、群体中的表达差异。

---

## 3. Structural Topic Model（STM）：统一的结构化建模框架

### 3.1 STM 的基本介绍

由 Roberts 等人提出，STM 融合了： CTM 的相关性建模； DMR 的先验回归机制； SAGE 的内容偏移机制。
这图是我在一门课程中回报topic models的发展的时候绘制的一个流程图，可以看到前文所提到的主题模型的演进：

![revolution of LDA](./revolution%20of%20LDA.png)




特别适用于社会科学研究中的复杂问题，例如： “谁在讨论？”“何时何地讨论？” “用何种措辞讨论？”

#### 生成机制包括两个通道：

- **主题流行度（Prevalence）通道：**
  - 文档级主题分布依赖元信息：  
    $\theta_d \sim \mathrm{LogisticNormal}(X_d \gamma, \Sigma)$

- **内容（Content）通道：**
  - 词分布受元信息调制的稀疏偏移：  
    $\log{\phi_{kw}^{(d)}} = \mu_w + \delta_{kw}(W^{(c)}(X_d))$

- **推断方法：**
  - 变分 EM 或半协程推断；
  - 同时估计主题结构、元数据效应、词项差异。


---

## 4. 小结与展望

本文系统回顾了从 LDA 到 STM 的主题模型技术演进。

近年来，基于深度学习和嵌入技术的新型模型不断涌现，以 **BERTopic** 为代表：

- 结合预训练语言模型（如 BERT）和聚类算法；
- 能自动确定主题数量；
- 灵活捕捉文本中的细粒度主题与语义特征；
- 大幅提升模型质量与易用性。

### 未来研究与应用的潜在方向：

1. **预训练模型融合：**
   - 深度融合 Transformer 架构与主题建模；
   - 提升语义理解与主题发现能力。

2. **多模态数据建模：**
   - 结合文本、图像、音频等多模态数据；
   - 构建更具表达力的主题模型。

3. **动态化与实时性：**
   - 实现在线更新与实时主题监控；
   - 应对数据流场景。

4. **可解释性与应用友好性：**
   - 增强模型解释能力；
   - 降低非技术用户的使用门槛。

---


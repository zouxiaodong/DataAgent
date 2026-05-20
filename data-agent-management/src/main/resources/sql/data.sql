-- 初始化数据文件
-- 只在表为空时插入示例数据

-- 业务知识示例数据
INSERT IGNORE INTO `business_knowledge` (`id`, `business_term`, `description`, `synonyms`, `is_recall`, `agent_id`, `created_time`, `updated_time`) VALUES
(1, '人口总数', '全国及各省份的常住人口总数，单位为万人', '总人口,人口数量,人口规模', 1, 1, NOW(), NOW()),
(2, '年龄结构', '人口按年龄段的分布情况，包括少年、劳动年龄人口、老年人口等', '年龄分布,年龄段,老龄化', 1, 1, NOW(), NOW()),
(3, '性别比例', '男性与女性人口的比例，通常以每100名女性对应的男性数量表示', '性别比,男女比例', 1, 1, NOW(), NOW()),
(4, '城乡分布', '人口在城镇和乡村之间的分布情况', '城镇化率,城镇人口,农村人口', 1, 1, NOW(), NOW()),
(5, 'Customer Retention Rate', 'The percentage of customers who continue to use a service over a given period.', 'retention, customer loyalty', 0, 2, NOW(), NOW());

-- 语义模型示例数据（匹配 china_population_db 实际表结构）
INSERT IGNORE INTO `semantic_model` (`id`, `agent_id`, `datasource_id`, `table_name`, `column_name`, `business_name`, `synonyms`, `business_description`, `column_comment`, `data_type`, `created_time`, `updated_time`, `status`) VALUES
(1, 1, 2, 'population_total', 'year', '年份', '年度,统计年份', '数据统计的年份', '统计年份', 'integer', NOW(), NOW(), 1),
(2, 1, 2, 'population_total', 'population', '人口总数', '总人口,人口数量', '全国常住人口总数，单位为万人', '常住人口总数(万人)', 'decimal', NOW(), NOW(), 1),
(3, 1, 2, 'population_total', 'urban_population', '城镇人口', '城市人口', '城镇常住人口数量', '城镇人口(万人)', 'decimal', NOW(), NOW(), 1),
(4, 1, 2, 'population_total', 'rural_population', '乡村人口', '农村人口', '乡村常住人口数量', '乡村人口(万人)', 'decimal', NOW(), NOW(), 1),
(5, 1, 2, 'age_structure', 'age_group', '年龄组', '年龄段', '人口年龄分组名称', '年龄分组', 'varchar', NOW(), NOW(), 1),
(6, 1, 2, 'age_structure', 'population', '人口数', '人口数量', '该年龄段的人口数量', '人口数(万人)', 'decimal', NOW(), NOW(), 1),
(7, 1, 2, 'age_structure', 'percentage', '占比', '比例,百分比', '该年龄段人口占总人口的比例', '占比(%)', 'decimal', NOW(), NOW(), 1),
(8, 1, 2, 'gender_ratio', 'year', '年份', '年度', '统计年份', '统计年份', 'integer', NOW(), NOW(), 1),
(9, 1, 2, 'gender_ratio', 'ratio', '性别比', '男女比例,性别比例', '每100名女性对应的男性数量', '性别比', 'decimal', NOW(), NOW(), 1),
(10, 1, 2, 'province_population', 'province', '省份', '省,地区', '省级行政区名称', '省份名称', 'varchar', NOW(), NOW(), 1),
(11, 1, 2, 'province_population', 'population', '人口数', '总人口,人口数量', '该省份常住人口总数', '人口数(万人)', 'decimal', NOW(), NOW(), 1),
(12, 1, 2, 'urban_rural_distribution', 'year', '年份', '年度', '统计年份', '统计年份', 'integer', NOW(), NOW(), 1),
(13, 1, 2, 'urban_rural_distribution', 'urban_rate', '城镇化率', '城镇人口比例', '城镇人口占总人口的比例', '城镇化率(%)', 'decimal', NOW(), NOW(), 1),
(14, 2, 1, 'customer_metrics', 'retention_pct', 'customerRetentionRate', 'retention rate, loyalty rate', 'Percentage of retained customers', '客户保留率', 'decimal', NOW(), NOW(), 0);

-- 智能体示例数据
INSERT IGNORE INTO `agent` (`id`, `name`, `description`, `avatar`, `status`, `api_key`, `api_key_enabled`, `prompt`, `category`, `admin_id`, `tags`, `create_time`, `update_time`) VALUES
(1, '中国人口GDP数据智能体', '专门处理中国人口和GDP相关数据查询分析的智能体', '/avatars/china-gdp-agent.png', 'draft', NULL, 0, '你是一个专业的数据分析助手，专门处理中国人口和GDP相关的数据查询。请根据用户的问题，生成准确的SQL查询语句。', '数据分析', 2100246635, '人口数据,GDP分析,经济统计', NOW(), NOW()),
(2, '销售数据分析智能体', '专注于销售数据分析和业务指标计算的智能体', '/avatars/sales-agent.png', 'draft', NULL, 0, '你是一个销售数据分析专家，能够帮助用户分析销售趋势、客户行为和业务指标。', '业务分析', 2100246635, '销售分析,业务指标,客户分析', NOW(), NOW()),
(3, '财务报表智能体', '专门处理财务数据和报表分析的智能体', '/avatars/finance-agent.png', 'draft', NULL, 0, '你是一个财务分析专家，专门处理财务数据查询和报表生成。', '财务分析', 2100246635, '财务数据,报表分析,会计', NOW(), NOW()),
(4, '库存管理智能体', '专注于库存数据管理和供应链分析的智能体', '/avatars/inventory-agent.png', 'draft', NULL, 0, '你是一个库存管理专家，能够帮助用户查询库存状态、分析供应链数据。', '供应链', 2100246635, '库存管理,供应链,物流', NOW(), NOW());

-- 智能体知识示例数据
INSERT IGNORE INTO `agent_knowledge` (`id`, `agent_id`, `title`, `content`, `type`, `is_recall`, `embedding_status`, `file_type`, `created_time`, `updated_time`) VALUES 
(1, 1, '中国人口统计数据说明', '中国人口统计数据包含了历年的人口总数、性别比例、年龄结构、城乡分布等详细信息。数据来源于国家统计局，具有权威性和准确性。查询时请注意数据的时间范围和统计口径。', 'DOCUMENT', 1, 'PENDING', 'text', NOW(), NOW()),
(2, 1, 'GDP数据使用指南', 'GDP（国内生产总值）数据反映了国家经济发展水平。包含名义GDP、实际GDP、GDP增长率等指标。数据按季度和年度进行统计，支持按地区、行业进行分类查询。', 'DOCUMENT', 1, 'PENDING', 'text', NOW(), NOW()),
(3, 1, '常见查询问题', '问：如何查询2023年的人口数据？\n答：可以使用"SELECT * FROM population WHERE year = 2023"进行查询。\n\n问：如何计算GDP增长率？\n答：GDP增长率 = (当年GDP - 上年GDP) / 上年GDP * 100%', 'QA', 1, 'PENDING', 'text', NOW(), NOW()),
(4, 2, '销售数据字段说明', '销售数据表包含以下关键字段：\n- sales_amount：销售金额\n- customer_id：客户ID\n- product_id：产品ID\n- sales_date：销售日期\n- region：销售区域\n- sales_rep：销售代表', 'DOCUMENT', 1, 'PENDING', 'text', NOW(), NOW()),
(5, 2, '客户分析指标体系', '客户分析包含多个维度：\n1. 客户价值分析：RFM模型（最近购买时间、购买频次、购买金额）\n2. 客户生命周期：新客户、活跃客户、流失客户\n3. 客户满意度：NPS评分、满意度调研\n4. 客户行为分析：购买偏好、渠道偏好', 'DOCUMENT', 1, 'PENDING', 'text', NOW(), NOW()),
(6, 3, '财务报表模板', '标准财务报表包含：\n1. 资产负债表：反映企业财务状况\n2. 利润表：反映企业经营成果\n3. 现金流量表：反映企业现金流动情况\n4. 所有者权益变动表：反映股东权益变化', 'DOCUMENT', 1, 'PENDING', 'pdf', NOW(), NOW()),
(7, 4, '库存管理最佳实践', '库存管理的核心要点：\n1. 安全库存设置：确保不断货\n2. ABC分类管理：重点管理A类物料\n3. 先进先出原则：避免库存积压\n4. 定期盘点：确保数据准确性\n5. 供应商管理：建立稳定供应关系', 'DOCUMENT', 1, 'PENDING', 'text', NOW(), NOW());

-- 数据源示例数据
-- 示例数据源可以运行docker-compose-datasource.yml建立，或者手动修改为自己的数据源
INSERT IGNORE INTO `datasource` (`id`, `name`, `type`, `host`, `port`, `database_name`, `username`, `password`, `connection_url`, `status`, `test_status`, `description`, `creator_id`, `create_time`, `update_time`) VALUES 
(1, '生产环境MySQL数据库', 'mysql', 'mysql-data', 3306, 'product_db', '', '', 'jdbc:mysql://mysql-data:3306/product_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true', 'inactive', 'unknown', '生产环境主数据库，包含核心业务数据', 2100246635, NOW(), NOW()),
(2, '数据仓库PostgreSQL', 'postgresql', 'data-agent-postgres-datasource', 5432, 'china_population_db|public', 'postgres', 'postgres', 'jdbc:postgresql://data-agent-postgres-datasource:5432/china_population_db?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai', 'inactive', 'unknown', '数据仓库，用于数据分析和报表生成', 2100246635, NOW(), NOW());

-- 智能体数据源关联示例数据
INSERT IGNORE INTO `agent_datasource` (`id`, `agent_id`, `datasource_id`, `is_active`, `create_time`, `update_time`) VALUES 
(1, 1, 2, 0, NOW(), NOW()),  -- 中国人口GDP数据智能体使用数据仓库
(2, 2, 1, 0, NOW(), NOW()),  -- 销售数据分析智能体使用生产环境数据库
(3, 3, 1, 0, NOW(), NOW()),  -- 财务报表智能体使用生产环境数据库
(4, 4, 1, 0, NOW(), NOW());  -- 库存管理智能体使用生产环境数据库

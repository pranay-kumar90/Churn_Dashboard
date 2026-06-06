-- Query 1 : Overall churn rate
select 
       count(*) as total_customers,
       sum(Churn) as Churned_customers,
       round(sum(churn) * 100.0 / count(*),2) as churn_rate_percentage
from churncleaned;
       
-- Query 2 : Churn by conrtact type
select 
      Contract,
      count(*) as total,
      sum(Churn) as Churned,
      round(avg(churn) *100 ,2) as churn_rate
from churncleaned
group by contract
order by churn_rate desc;

-- Query 3 : Average tenure - churned vs retained
select 
      case when churn = 1 then 'Churned' else 'Retained' end as status,
      round(avg(tenure), 1) as avg_tenure_months,
      round(avg(monthlycharges),2) as avg_monthly_charges
from churncleaned
group by churn;

-- Query 4 : Churn by payment method
SELECT 
    PaymentMethod,
    COUNT(*) AS total,
    ROUND(AVG(Churn) * 100, 2) AS churn_rate
FROM churncleaned
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- Query 5: High value customers at risk (monthly charges > 70, churned)
SELECT 
    Contract,
    COUNT(*) AS high_value_churned,
    ROUND(AVG(MonthlyCharges), 2) AS avg_charges,
    ROUND(AVG(tenure), 1) AS avg_tenure
FROM churncleaned
WHERE Churn = 1 AND MonthlyCharges > 70
GROUP BY Contract;

-- Query 6: Window function — churn rank by contract and tenure group
SELECT 
    Contract,
    tenure_group,
    COUNT(*) AS customers,
    SUM(Churn) AS churned,
    ROUND(AVG(Churn)*100, 2) AS churn_rate,
    RANK() OVER (PARTITION BY Contract ORDER BY AVG(Churn) DESC) AS risk_rank
FROM churncleaned
GROUP BY Contract, tenure_group;

create database bank_loan_db;
use bank_loan_db;
select * from financial_loan;
-- Step 1: Make ID as Primary Key
ALTER TABLE financial_loan
MODIFY COLUMN id INT,
ADD PRIMARY KEY (id);

-- Step 2: Add new date columns
ALTER TABLE financial_loan
ADD COLUMN issue_date_converted DATE,
ADD COLUMN last_credit_pull_date_converted DATE,
ADD COLUMN last_payment_date_converted DATE,
ADD COLUMN next_payment_date_converted DATE;

-- Step 3: Convert text dates to proper DATE format
UPDATE financial_loan
SET issue_date_converted = STR_TO_DATE(issue_date, '%d-%m-%Y'),
    last_credit_pull_date_converted = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
    last_payment_date_converted = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
    next_payment_date_converted = STR_TO_DATE(next_payment_date, '%d-%m-%Y');

-- Step 4: Drop old text date columns
ALTER TABLE financial_loan
DROP COLUMN issue_date,
DROP COLUMN last_credit_pull_date,
DROP COLUMN last_payment_date,
DROP COLUMN next_payment_date;

-- Step 5: Rename converted columns to original names
ALTER TABLE financial_loan
CHANGE issue_date_converted issue_date DATE,
CHANGE last_credit_pull_date_converted last_credit_pull_date DATE,
CHANGE last_payment_date_converted last_payment_date DATE,
CHANGE next_payment_date_converted next_payment_date DATE;


select count(id) as Total_Loan_Applications from bank_loan_db.financial_loan;

select count(id) as MTD_Total_Loan_Applications from bank_loan_db.financial_loan
where month(issue_date) = 12 and year(issue_date) =2021;

select count(id) as PMTD_Total_Loan_Applications from bank_loan_db.financial_loan
where month(issue_date) = 11 and year(issue_date) =2021;

select sum(loan_amount) as Total_Funded_Amount from bank_loan_db.financial_loan;

select sum(loan_amount) as MTD_Total_Funded_Amount from bank_loan_db.financial_loan
where month(issue_date) = 12 and year(issue_date) = 2021;

select sum(loan_amount) as PMTD_Total_Funded_Amount from bank_loan_db.financial_loan
where month(issue_date) = 11 and year(issue_date) = 2021;

Select sum(total_payment) As Total_Amount_Received from bank_loan_db.financial_loan;

Select sum(total_payment) As MTD_Total_Amount_Received from bank_loan_db.financial_loan
where month(issue_date) = 12 And year(issue_date) = 2021;

Select sum(total_payment) As PMTD_Total_Amount_Received From bank_loan_db.financial_loan
Where month (issue_date) = 11 And year (issue_date) = 2021;

Select cast(avg(int_rate) as decimal(10,4)) * 100 as Average_Interest_Rate from bank_loan_db.financial_loan;

Select cast(avg(int_rate) as decimal(10,4)) * 100 as MTD_Average_Interest_Rate from bank_loan_db.financial_loan
Where month(issue_date) = 12 And year(issue_date) = 2021;

Select cast(avg(int_rate) as decimal(10,4)) * 100 as _PMTD_Average_Interest_Rate from bank_loan_db.financial_loan
Where month(issue_date) = 11 And year(issue_date) = 2021;

Select round(avg(dti),4) * 100 As Average_DTI From bank_loan_db.financial_loan;

Select cast(avg(dti)as decimal(10,4)) * 100 As MTD_Average_DTI From bank_loan_db.financial_loan
Where month(issue_date) = 12 And year(issue_date) = 2021;

Select cast(avg(dti)as decimal(10,4)) * 100 As PMTD_Average_DTI From bank_loan_db.financial_loan
Where month(issue_date) = 11 And year(issue_date) = 2021;

Select 
	FLOOR(
		(count(case when loan_status = "Fully Paid" OR loan_status = "Current" Then id END)* 100)
		/ count(id)
	)as Good_Loan_Percentage
from bank_loan_db.financial_loan;

Select count(id) As Good_Loan_Applications From bank_loan_db.financial_loan
Where loan_status = "Fully Paid" OR loan_status = "Current";

Select sum(total_payment) As Good_Loan_Received_Amount From bank_loan_db.financial_loan
Where loan_status = "Fully Paid" OR loan_status = "Current";

Select 
	Floor(
		(count(case when loan_status = "Charged Off" Then id END)* 100)
		/ count(id)
	) As Bad_Loan_Percentage
From bank_loan_db.financial_loan;

Select count(id) As Bad_Loan_Applications From bank_loan_db.financial_loan
Where loan_status = "Charged Off";

Select sum(loan_amount) As Bad_Loan_Funded_Amount From bank_loan_db.financial_loan
Where loan_status = "Charged Off";

Select sum(total_payment) As Bad_Loan_Received_Amount From bank_loan_db.financial_loan
Where loan_status = "Charged Off";

Select 
	loan_status,
    count(id) as Total_Applications,
    sum(total_payment) as Total_Amount_Received,
    sum(loan_amount) as Total_Funded_Amount,
    avg(int_rate) * 100 AS Interest_Rate,
    avg(dti*100) as DTI
From
	bank_loan_db.financial_loan
group by
	loan_status;
    
Select 
	loan_status,
   	 sum(total_payment) As MTD_Total_Amount_Received,
   	 sum(loan_amount) As MTD_Total_Funded_Amount
From bank_loan_db.financial_loan
Where Month(issue_date) = 12
group by loan_status;

select month(issue_date) as Month_Number,
	monthname(issue_date) as Month_Name,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received
From bank_loan_db.financial_loan
group by month(issue_date),monthname(issue_date)
order by month(issue_date);

select 
	address_state As State,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received
From bank_loan_db.financial_loan
group by address_state
order by address_state;

Select 
	term As Term,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received
From bank_loan_db.financial_loan
group by term
order by term;

Select 
	emp_length as Emp_Length,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received
From bank_loan_db.financial_loan
group by emp_length
order by emp_length;

Select 
	purpose as Purpose,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received
From bank_loan_db.financial_loan
group by purpose
order by purpose;

Select 
	home_ownership As Home_Ownership,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received
From bank_loan_db.financial_loan
group by home_ownership
order by home_ownership;




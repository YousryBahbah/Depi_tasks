using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task4OOP_c_
{
    internal class Bank
    {
        string Bankname;
        string BranchCode;
        List<Customer> customers;
        List<CurrentAcc> currentAccounts;
        List<SavingAcc> savingAccounts;

        public Bank(string Bankname, string BranchCode)
        {
            this.Bankname = Bankname;
            this.BranchCode = BranchCode;
            customers = new List<Customer>();
            currentAccounts = new List<CurrentAcc>();
            savingAccounts = new List<SavingAcc>();
        }

        public void addCustomer(Customer customer)
        {
            customers.Add(customer);
            Console.WriteLine($"Customer {customer.getName()} added successfully");
        }

        public Customer findCustomer(string name)
        {
            foreach (Customer customer in customers)
            {
                if (customer.getName().ToLower() == name.ToLower())
                {
                    return customer;
                }
            }
            return null;
        }

        public Customer findCustomerByNationalId(int nationalId)
        {
            foreach (Customer customer in customers)
            {
                if (customer.getNationalId() == nationalId)
                {
                    return customer;
                }
            }
            return null;
        }

        public void removeCustomer(Customer customer)
        {
            // Check if customer has any accounts with money
            bool canRemove = true;
            int totalBalance = 0;

            foreach (CurrentAcc acc in currentAccounts)
            {
                if (acc.getName() == customer.getName())
                {
                    totalBalance += acc.getBalance();
                }
            }

            foreach (SavingAcc acc in savingAccounts)
            {
                if (acc.getName() == customer.getName())
                {
                    totalBalance += acc.getBalance();
                }
            }

            if (totalBalance > 0)
            {
                Console.WriteLine($"Cannot remove customer {customer.getName()}. They have ${totalBalance} in their accounts");
            }
            else
            {
                customers.Remove(customer);
                Console.WriteLine($"Customer {customer.getName()} removed successfully");
            }
        }

        public void createCurrentAccount(Customer customer, int overdraftLimit, int balance)
        {
            CurrentAcc newAccount = new CurrentAcc(customer.getName(), customer.getNationalId(), customer.getBirthDate(), overdraftLimit, balance);
            currentAccounts.Add(newAccount);
            Console.WriteLine($"Current account created for {customer.getName()}. Account number: {newAccount.getAccountNumber()}");
        }

        public void createSavingAccount(Customer customer, int interestRate, int balance)
        {
            SavingAcc newAccount = new SavingAcc(customer.getName(), customer.getNationalId(), customer.getBirthDate(), interestRate, balance);
            savingAccounts.Add(newAccount);
            Console.WriteLine($"Savings account created for {customer.getName()}. Account number: {newAccount.getAccountNumber()}");
        }

        public CurrentAcc findCurrentAccount(int accountNumber)
        {
            foreach (CurrentAcc account in currentAccounts)
            {
                if (account.getAccountNumber() == accountNumber)
                {
                    return account;
                }
            }
            return null;
        }

        public SavingAcc findSavingAccount(int accountNumber)
        {
            foreach (SavingAcc account in savingAccounts)
            {
                if (account.getAccountNumber() == accountNumber)
                {
                    return account;
                }
            }
            return null;
        }

        public void showAllCustomers()
        {
            Console.WriteLine($"--- All Customers in {Bankname} ---");
            if (customers.Count == 0)
            {
                Console.WriteLine("No customers found");
            }
            else
            {
                foreach (Customer customer in customers)
                {
                    customer.showCustomer();
                    Console.WriteLine();
                }
            }
        }

        public void showBankReport()
        {
            Console.WriteLine($"========== {Bankname} - Branch: {BranchCode} ==========");
            Console.WriteLine($"Total Customers: {customers.Count}");
            Console.WriteLine($"Total Current Accounts: {currentAccounts.Count}");
            Console.WriteLine($"Total Saving Accounts: {savingAccounts.Count}");
            Console.WriteLine($"Report Date: {DateTime.Now}");
            Console.WriteLine();

            int totalMoney = 0;

            Console.WriteLine("--- Customer Details ---");
            foreach (Customer customer in customers)
            {
                Console.WriteLine($"Customer: {customer.getName()} (National ID: {customer.getNationalId()})");

                int customerBalance = 0;

                // Show current accounts
                foreach (CurrentAcc acc in currentAccounts)
                {
                    if (acc.getName() == customer.getName())
                    {
                        Console.WriteLine($"  Current Account {acc.getAccountNumber()}: ${acc.getBalance()}");
                        customerBalance += acc.getBalance();
                    }
                }

                // Show saving accounts
                foreach (SavingAcc acc in savingAccounts)
                {
                    if (acc.getName() == customer.getName())
                    {
                        Console.WriteLine($"  Savings Account {acc.getAccountNumber()}: ${acc.getBalance()}");
                        customerBalance += acc.getBalance();
                    }
                }

                Console.WriteLine($"  Customer Total Balance: ${customerBalance}");
                totalMoney += customerBalance;
                Console.WriteLine();
            }

            Console.WriteLine($"TOTAL BANK MONEY: ${totalMoney}");
            Console.WriteLine("==================================================");
        }

        public void calculateAllInterest()
        {
            Console.WriteLine("--- Monthly Interest Calculation ---");
            foreach (SavingAcc account in savingAccounts)
            {
                account.showInterestProjection();
                Console.WriteLine();
            }
        }

        public string getBankName()
        {
            return Bankname;
        }

        public string getBranchCode()
        {
            return BranchCode;
        }
    }
}

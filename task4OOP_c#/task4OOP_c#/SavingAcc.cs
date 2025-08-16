using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task4OOP_c_
{
    internal class SavingAcc : Accounts
    {
        int interestRate = 5;

        public SavingAcc(string _fullname, int _nationalid, DateTime _dateOfBirth, int interestRate, int balance) : base(_fullname, _nationalid, _dateOfBirth)
        {
            this.interestRate = interestRate;
            Balance = balance;
            OpenDate = DateTime.Now;
            accnum = generateAccnum();

            if (balance > 0)
            {
                addTransaction($"Initial deposit: ${balance}");
            }
        }

        private int generateAccnum()
        {
            Random rand = new Random();
            int num = rand.Next(1, 2000);
            return num;
        }

        public void deposit(int depo)
        {
            if (depo > 0)
            {
                Balance += depo;
                addTransaction($"Deposit: ${depo}, New Balance: ${Balance}");
                Console.WriteLine($"Deposited ${depo}. New balance: ${Balance}");
            }
            else
            {
                Console.WriteLine("Deposit amount must be positive");
            }
        }

        public void withdraw(int withdrawn)
        {
            if (withdrawn <= 0)
            {
                Console.WriteLine("Withdraw amount must be positive");
                return;
            }

            if (withdrawn > Balance)
            {
                Console.WriteLine("Not enough money! Savings account cannot go below zero");
                Console.WriteLine($"Your balance is ${Balance}");
                return;
            }

            Balance -= withdrawn;
            addTransaction($"Withdrawal: ${withdrawn}, New Balance: ${Balance}");
            Console.WriteLine($"Withdrew ${withdrawn}. New balance: ${Balance}");
        }

        public int calculateMonthlyInterest()
        {
            int monthlyInterest = (Balance * interestRate) / 100 / 12;
            return monthlyInterest;
        }

        public void applyInterest()
        {
            int interest = calculateMonthlyInterest();
            Balance += interest;
            addTransaction($"Monthly interest applied: ${interest}, New Balance: ${Balance}");
            Console.WriteLine($"Interest of ${interest} added to your account");
            Console.WriteLine($"New balance: ${Balance}");
        }

        public int getInterestRate()
        {
            return interestRate;
        }

        public void showAccount()
        {
            Console.WriteLine($"--- Savings Account {accnum} ---");
            Console.WriteLine($"Owner: {_fullname}");
            Console.WriteLine($"Balance: ${Balance}");
            Console.WriteLine($"Interest Rate: {interestRate}% per year");
            Console.WriteLine($"Monthly Interest: ${calculateMonthlyInterest()}");
            Console.WriteLine($"Opened: {OpenDate}");
        }

        public void showInterestProjection()
        {
            Console.WriteLine($"--- Interest Projection for Account {accnum} ---");
            Console.WriteLine($"Current Balance: ${Balance}");
            Console.WriteLine($"Interest Rate: {interestRate}% per year");
            Console.WriteLine($"Monthly Interest: ${calculateMonthlyInterest()}");
            Console.WriteLine($"Yearly Interest: ${(Balance * interestRate) / 100}");
        }
    }
}

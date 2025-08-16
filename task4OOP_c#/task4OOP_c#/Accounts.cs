using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task4OOP_c_
{
    internal class Accounts : Customer
    {
        protected int Balance;
        protected DateTime OpenDate;
        protected int accnum;
        protected List<string> transactions;

        public Accounts(string _fullname, int _nationalid, DateTime _dateOfBirth) : base(_fullname, _nationalid, _dateOfBirth)
        {
            transactions = new List<string>();
        }

        // Simple methods to get account info
        public int getBalance()
        {
            return Balance;
        }

        public int getAccountNumber()
        {
            return accnum;
        }

        public DateTime getOpenDate()
        {
            return OpenDate;
        }

        public void showTransactions()
        {
            Console.WriteLine($"--- Transactions for Account {accnum} ---");
            if (transactions.Count == 0)
            {
                Console.WriteLine("No transactions yet");
            }
            else
            {
                foreach (string transaction in transactions)
                {
                    Console.WriteLine(transaction);
                }
            }
        }

        public void addTransaction(string transaction)
        {
            transactions.Add(DateTime.Now + ": " + transaction);
        }
    }
}

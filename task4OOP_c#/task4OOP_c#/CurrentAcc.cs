using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task4OOP_c_
{
    internal class CurrentAcc : Accounts
    {
        int OverdraftLimit = 10;

        public CurrentAcc(string _fullname, int _nationalid, DateTime _dateOfBirth, int OverdraftLimit, int balance) : base(_fullname, _nationalid, _dateOfBirth)
        {
            this.Balance = balance;
            this.OpenDate = DateTime.Now;
            this.OverdraftLimit = OverdraftLimit;
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

        public void Withdraw(int withdrawn)
        {
            if (withdrawn <= 0)
            {
                Console.WriteLine("Withdraw amount must be positive");
                return;
            }

            if (withdrawn > (Balance + OverdraftLimit))
            {
                Console.WriteLine("Off limit! Try another number");
                Console.WriteLine($"Your balance is ${Balance} and overdraft limit is ${OverdraftLimit}");
                Console.WriteLine($"Maximum you can withdraw: ${Balance + OverdraftLimit}");
                return;
            }

            Balance -= withdrawn;
            addTransaction($"Withdrawal: ${withdrawn}, New Balance: ${Balance}");
            Console.WriteLine($"Withdrew ${withdrawn}. New balance: ${Balance}");

            if (Balance < 0)
            {
                Console.WriteLine($"Warning: You are overdrawn by ${Math.Abs(Balance)}");
            }
        }

        public void transfer(CurrentAcc sender, CurrentAcc reciever, int amount)
        {
            if (amount <= 0)
            {
                Console.WriteLine("Transfer amount must be positive");
                return;
            }

            if (amount > (sender.Balance + sender.OverdraftLimit))
            {
                Console.WriteLine("Not enough money to transfer");
                return;
            }

            sender.Balance -= amount;
            reciever.Balance += amount;

            sender.addTransaction($"Transfer OUT to Account {reciever.accnum}: ${amount}, New Balance: ${sender.Balance}");
            reciever.addTransaction($"Transfer IN from Account {sender.accnum}: ${amount}, New Balance: ${reciever.Balance}");

            Console.WriteLine($"Transferred ${amount} from account {sender.accnum} to account {reciever.accnum}");
            Console.WriteLine($"Sender balance: ${sender.Balance}");
            Console.WriteLine($"Receiver balance: ${reciever.Balance}");
        }

        public int getOverdraftLimit()
        {
            return OverdraftLimit;
        }

        public void showAccount()
        {
            Console.WriteLine($"--- Current Account {accnum} ---");
            Console.WriteLine($"Owner: {_fullname}");
            Console.WriteLine($"Balance: ${Balance}");
            Console.WriteLine($"Overdraft Limit: ${OverdraftLimit}");
            Console.WriteLine($"Available Money: ${Balance + OverdraftLimit}");
            Console.WriteLine($"Opened: {OpenDate}");
        }
    }
}

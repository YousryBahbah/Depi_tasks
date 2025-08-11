using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task2_c_
{
    internal class SavingAccount : TheBank
    {
        decimal InterestRate;
        public override decimal CalculateInterest() { return Balance* InterestRate / 100; }
        public override void ShowAccountDetails()
        {
            Console.WriteLine(FullName);
            Console.WriteLine(phoneNumber);
            Console.WriteLine(Balance);
            Console.WriteLine(NationalId);
            Console.WriteLine(InterestRate);
        }
    }
}

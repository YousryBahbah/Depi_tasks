using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task2_c_
{
    internal class CurrentAccount : TheBank
    {
        decimal OverdraftLimit;
        public override decimal CalculateInterest() { return 0; }
        public override void ShowAccountDetails()
        {
            Console.WriteLine(FullName);
            Console.WriteLine(phoneNumber);
            Console.WriteLine(Balance);
            Console.WriteLine(NationalId);
            Console.WriteLine(OverdraftLimit);
        }

    }
}

namespace task2_c_
{
    internal class Program
    {
        static void Main(string[] args)
        {
          SavingAccount sa = new SavingAccount(); 
         CurrentAccount ca = new CurrentAccount();
            List<TheBank> accounts = new List<TheBank>() { sa ,ca };
            foreach (var account in accounts)
            {
                account.ShowAccountDetails();
                account.CalculateInterest();
            }
            
        }
    }
}

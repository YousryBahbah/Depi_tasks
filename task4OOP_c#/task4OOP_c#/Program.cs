namespace task4OOP_c_
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Bank myBank = new Bank("My First Bank", "BR001");
            Console.WriteLine($"Welcome to {myBank.getBankName()}!");

            while (true)
            {
                Console.WriteLine("\n=== Banking System Menu ===");
                Console.WriteLine("1. Add New Customer");
                Console.WriteLine("2. Update Customer Details");
                Console.WriteLine("3. Remove Customer");
                Console.WriteLine("4. Search Customer");
                Console.WriteLine("5. Create Current Account");
                Console.WriteLine("6. Create Savings Account");
                Console.WriteLine("7. Deposit Money");
                Console.WriteLine("8. Withdraw Money");
                Console.WriteLine("9. Transfer Money");
                Console.WriteLine("10. Show Transaction History");
                Console.WriteLine("11. Show All Customers");
                Console.WriteLine("12. Show Bank Report");
                Console.WriteLine("13. Calculate Monthly Interest");
                Console.WriteLine("14. Apply Interest to Savings Accounts");
                Console.WriteLine("15. Exit");
                Console.Write("Choose option (1-15): ");

                string choice = Console.ReadLine();

                if (choice == "1")
                {
                    Console.Write("Enter customer name: ");
                    string name = Console.ReadLine();
                    Console.Write("Enter national ID: ");
                    int nationalId = int.Parse(Console.ReadLine());
                    Console.Write("Enter birth year: ");
                    int year = int.Parse(Console.ReadLine());

                    Customer newCustomer = new Customer(name, nationalId, new DateTime(year, 1, 1));
                    myBank.addCustomer(newCustomer);
                }
                else if (choice == "2")
                {
                    Console.Write("Enter customer name to update: ");
                    string name = Console.ReadLine();
                    Customer customer = myBank.findCustomer(name);

                    if (customer != null)
                    {
                        Console.Write("Enter new name: ");
                        string newName = Console.ReadLine();
                        Console.Write("Enter new birth year: ");
                        int newYear = int.Parse(Console.ReadLine());

                        customer.Update(newName, new DateTime(newYear, 1, 1));
                        Console.WriteLine("Customer updated successfully!");
                    }
                    else
                    {
                        Console.WriteLine("Customer not found!");
                    }
                }
                else if (choice == "3")
                {
                    Console.Write("Enter customer name to remove: ");
                    string name = Console.ReadLine();
                    Customer customer = myBank.findCustomer(name);

                    if (customer != null)
                    {
                        myBank.removeCustomer(customer);
                    }
                    else
                    {
                        Console.WriteLine("Customer not found!");
                    }
                }
                else if (choice == "4")
                {
                    Console.Write("Enter customer name: ");
                    string name = Console.ReadLine();
                    Customer customer = myBank.findCustomer(name);

                    if (customer != null)
                    {
                        customer.showCustomer();
                    }
                    else
                    {
                        Console.WriteLine("Customer not found!");
                    }
                }
                else if (choice == "5")
                {
                    Console.Write("Enter customer name: ");
                    string name = Console.ReadLine();
                    Customer customer = myBank.findCustomer(name);

                    if (customer != null)
                    {
                        Console.Write("Enter overdraft limit: ");
                        int overdraft = int.Parse(Console.ReadLine());
                        Console.Write("Enter starting balance: ");
                        int balance = int.Parse(Console.ReadLine());

                        myBank.createCurrentAccount(customer, overdraft, balance);
                    }
                    else
                    {
                        Console.WriteLine("Customer not found!");
                    }
                }
                else if (choice == "6")
                {
                    Console.Write("Enter customer name: ");
                    string name = Console.ReadLine();
                    Customer customer = myBank.findCustomer(name);

                    if (customer != null)
                    {
                        Console.Write("Enter interest rate: ");
                        int rate = int.Parse(Console.ReadLine());
                        Console.Write("Enter starting balance: ");
                        int balance = int.Parse(Console.ReadLine());

                        myBank.createSavingAccount(customer, rate, balance);
                    }
                    else
                    {
                        Console.WriteLine("Customer not found!");
                    }
                }
                else if (choice == "7")
                {
                    Console.Write("Enter account number: ");
                    int accNum = int.Parse(Console.ReadLine());
                    Console.Write("Enter deposit amount: ");
                    int amount = int.Parse(Console.ReadLine());

                    CurrentAcc currentAcc = myBank.findCurrentAccount(accNum);
                    SavingAcc savingAcc = myBank.findSavingAccount(accNum);

                    if (currentAcc != null)
                    {
                        currentAcc.deposit(amount);
                    }
                    else if (savingAcc != null)
                    {
                        savingAcc.deposit(amount);
                    }
                    else
                    {
                        Console.WriteLine("Account not found!");
                    }
                }
                else if (choice == "8")
                {
                    
                    Console.Write("Enter account number: ");
                    int accNum = int.Parse(Console.ReadLine());
                    Console.Write("Enter withdraw amount: ");
                    int amount = int.Parse(Console.ReadLine());

                    CurrentAcc currentAcc = myBank.findCurrentAccount(accNum);
                    SavingAcc savingAcc = myBank.findSavingAccount(accNum);

                    if (currentAcc != null)
                    {
                        currentAcc.Withdraw(amount);
                    }
                    else if (savingAcc != null)
                    {
                        savingAcc.withdraw(amount);
                    }
                    else
                    {
                        Console.WriteLine("Account not found!");
                    }
                }
                else if (choice == "9")
                {
                    Console.Write("Enter sender account number: ");
                    int senderNum = int.Parse(Console.ReadLine());
                    Console.Write("Enter receiver account number: ");
                    int receiverNum = int.Parse(Console.ReadLine());
                    Console.Write("Enter transfer amount: ");
                    int amount = int.Parse(Console.ReadLine());

                    CurrentAcc sender = myBank.findCurrentAccount(senderNum);
                    CurrentAcc receiver = myBank.findCurrentAccount(receiverNum);

                    if (sender != null && receiver != null)
                    {
                        sender.transfer(sender, receiver, amount);
                    }
                    else
                    {
                        Console.WriteLine("One or both current accounts not found!");
                    }
                }
                else if (choice == "10")
                {
                    Console.Write("Enter account number: ");
                    int accNum = int.Parse(Console.ReadLine());

                    CurrentAcc currentAcc = myBank.findCurrentAccount(accNum);
                    SavingAcc savingAcc = myBank.findSavingAccount(accNum);

                    if (currentAcc != null)
                    {
                        currentAcc.showTransactions();
                    }
                    else if (savingAcc != null)
                    {
                        savingAcc.showTransactions();
                    }
                    else
                    {
                        Console.WriteLine("Account not found!");
                    }
                }
                else if (choice == "11")
                {
                    myBank.showAllCustomers();
                }
                else if (choice == "12")
                {
                    myBank.showBankReport();
                }
                else if (choice == "13")
                {
                    myBank.calculateAllInterest();
                }
                else if (choice == "14")
                {
                    Console.WriteLine("Applying interest to all savings accounts...");
                    Console.Write("Enter account number to apply interest: ");
                    int accNum = int.Parse(Console.ReadLine());

                    SavingAcc savingAcc = myBank.findSavingAccount(accNum);
                    if (savingAcc != null)
                    {
                        savingAcc.applyInterest();
                    }
                    else
                    {
                        Console.WriteLine("Savings account not found!");
                    }
                }
                else if (choice == "15")
                {
                    Console.WriteLine("Thank you for using the banking system!");
                    break;
                }
                else
                {
                    Console.WriteLine("Invalid choice! Please try again.");
                }

                Console.WriteLine("\nPress any key to continue...");
                Console.ReadKey();
                Console.Clear();
            }
        }
    }
}
   
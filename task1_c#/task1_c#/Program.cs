using System.Collections.Concurrent;

namespace task1_c_
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello!");
            Console.WriteLine("Input the first number: ");
            decimal Fnum = decimal.Parse(Console.ReadLine());
            Console.WriteLine("Input the second number: ");
            decimal Snum = decimal.Parse(Console.ReadLine());
            Console.WriteLine("What do you want to do with those numbers?");
            Console.WriteLine("[A]dd");
            Console.WriteLine("[S]ubtract");
            Console.WriteLine("[M]ultiply");
            char op = Convert.ToChar(Console.ReadLine());
            if (op == 'A' || op == 'a')
            {
                decimal num = Fnum + Snum;
                Console.WriteLine($"{Fnum} + {Snum} = {num}"); 
            }
            else if (op == 'S' || op == 's')
            {
                decimal num = Fnum - Snum;
                Console.WriteLine($"{Fnum} - {Snum} = {num}");
            }
            else if (op == 'M' || op == 'm')
            {
                decimal num = Fnum * Snum;
                Console.WriteLine($"{Fnum} * {Snum} = {num}");
            }
            else
            {
                Console.WriteLine("Invalid option");
            }
            Console.ReadKey();
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task4OOP_c_
{
    internal class Customer
    {
        int _id;
        protected string _fullname;
        protected int _nationalid;
        protected DateTime _dateOfBirth;

        public Customer(string _fullname, int _nationalid, DateTime _dateOfBirth)
        {
            _id = generateId();
            this._fullname = _fullname;
            this._nationalid = _nationalid;
            this._dateOfBirth = _dateOfBirth;
        }

        public void Update(string _fullname, DateTime _dateOfBirth)
        {
            this._fullname = _fullname;
            this._dateOfBirth = _dateOfBirth;
        }

        private int generateId()
        {
            Random rand = new Random();
            int id = rand.Next(1, 2000);
            return id;
        }

        public void search(List<Customer> c, string fullname, int nationalid)
        {
            foreach (Customer citem in c)
            {
                if (citem._fullname == fullname || citem._nationalid == nationalid)
                {
                    Console.WriteLine($"Fullname : {citem._fullname}");
                    Console.WriteLine($"National id : {citem._nationalid}");
                    Console.WriteLine($"DateOfBirth : {citem._dateOfBirth}");
                }
            }
        }

        // Simple methods to get customer info
        public string getName()
        {
            return _fullname;
        }

        public int getNationalId()
        {
            return _nationalid;
        }

        public int getId()
        {
            return _id;
        }

        public DateTime getBirthDate()
        {
            return _dateOfBirth;
        }

        public void showCustomer()
        {
            Console.WriteLine($"ID: {_id}");
            Console.WriteLine($"Name: {_fullname}");
            Console.WriteLine($"National ID: {_nationalid}");
            Console.WriteLine($"Birth Date: {_dateOfBirth}");
        }
    }
}

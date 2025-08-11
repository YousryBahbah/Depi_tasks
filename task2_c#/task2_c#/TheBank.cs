using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace task2_c_
{
    internal class TheBank
    {
        const string BankCode = "BNK001";
        public readonly DateTime CreatedDate;
        int _accountNumber;
        string _fullName;
        string _nationalID;
        string _phoneNumber;
        string _address;
        int  _balance ;  
        public TheBank()
        {
            _accountNumber = 0;
            _balance = 0;
            _fullName = "yousry";
            _nationalID = "123456789101112";
            _phoneNumber = "01007237750";
            _address = "MNF";
            CreatedDate = DateTime.Now;
        }
        public TheBank(  string fullName, string nationalID, string phonenumber, string address, int balance)
        {
            CreatedDate = DateTime.Now;
            _fullName = fullName;
            _nationalID = nationalID;
            _address = address;
            _phoneNumber = phonenumber;
            _balance = balance;
        }
        public TheBank(string fullName, string nationalID, string phonenumber, string address)
        {
            CreatedDate = DateTime.Now;
            _fullName = fullName;
            _nationalID = nationalID;
            _address = address;
            _phoneNumber = phonenumber;
            _balance = 0;
        }
        public int AccountNumber { set 
            {
                _accountNumber = value;
            }
        }
        public string FullName { get { return _fullName; } set 
            {
                if (string.IsNullOrEmpty(value)) {
                    Console.WriteLine("invalid");
                }
                else
                {
                    _fullName = value;
                }
            }
        }
        public string NationalId
        {
            get { return _nationalID; } set
            {
                if (value.Length != 14 ){
                    Console.WriteLine("invalid");
                }
                else
                {
                    _nationalID = value;
                }
            }
        }
        public string phoneNumber {  get { return _phoneNumber; } set
            {
                if (value.Length != 11 || value.Substring(0,2) != "01")
                {
                    Console.WriteLine("invalid");
                }
                else
                {
                    _phoneNumber = value;
                }
            } }
        public int Balance
        {
            get { return _balance; } set
            {
                if (value < 0)
                {
                    Console.WriteLine("invalid");
                }
                else { _balance = value; }
            }
        }
            public virtual void ShowAccountDetails()
        {
            Console.WriteLine(FullName);
            Console.WriteLine(phoneNumber);
            Console.WriteLine(Balance);
            Console.WriteLine(NationalId);
        }
            public bool IsValidNationalID() { if (_nationalID.Length != 14 )
            { return false; }
            return true; }

        public bool IsValidPhoneNumber ()
        {
            if (_phoneNumber.Length != 11 || _phoneNumber.Substring(0, 2) != "01")
            {
               return false;
            }
            else
            {
                return true;
            }
        }
        public virtual decimal CalculateInterest() => 0;
    }
}
    

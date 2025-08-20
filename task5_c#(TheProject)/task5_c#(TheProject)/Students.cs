using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task5_c__TheProject_
{
    internal class Students
    {
        int _ID;
        string _Name;
        string _Email;
        int _Score;
        string _Pass;

        public int ID { get => _ID; set => _ID = value; }
        public string Name { get => _Name; set => _Name = value; }
        public string Email { get => _Email; set => _Email = value; }
        public int Score { get => _Score; set => _Score = value; }
        public string Pass { get => _Pass; set => _Pass = value; }

        public List<Course> EnrolledInCourse { get; set; } = new List<Course>();
    }
}

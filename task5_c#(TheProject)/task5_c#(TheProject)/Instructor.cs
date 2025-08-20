using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task5_c__TheProject_
{
    internal class Instructor
    {
        int _ID;
        string _Name;
        string _Specialization;
        
        public int ID { get => _ID; set => _ID = value; }
        public string Name { get => _Name; set => _Name = value; }
        public string Specialization { get => _Specialization; set => _Specialization = value; }
        public List<Course> Teach { get; set; } = new List<Course>();
    }
}

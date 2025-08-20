using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task5_c__TheProject_
{
    internal class Course
    {
        string _Title;
        string _Description;
        string _Maximum_degree;
        public string Title { get => _Title; set => _Title = value; }
        public string Description { get => _Description; set => _Description = value; }
        public string Maximum_degree { get => _Maximum_degree; set => _Maximum_degree = value; }

        public List<Students> EnrolledStudent { get; set; } = new List<Students>();
        public List<Instructor> Instructor { get; set; } = new List<Instructor>();
        public List<Questions> Question { get; set; } = new List<Questions>();
        public List<Exam> Exams { get; set; } = new List<Exam>();

    }
}

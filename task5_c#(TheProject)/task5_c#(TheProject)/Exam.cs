using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace  task5_c__TheProject_
{
    internal class Exam
    {
        string _Title;
        string _IsStarted;

        public string Title { get => _Title; set => _Title = value; }
        public string IsStarted { get => _IsStarted; set => _IsStarted = value; }

        public Course Course { get; set; }
        public List<Questions> Questions { get; set; } = new List<Questions>();
    }
}

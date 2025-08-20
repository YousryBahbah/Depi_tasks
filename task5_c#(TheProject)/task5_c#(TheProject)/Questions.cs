using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task5_c__TheProject_
{
    internal class Questions
    {
        int _id;
        string _text;
        string _marks;

        public int Id { get => _id; set => _id = value; }
        public string Text { get => _text; set => _text = value; }
        public string Marks { get => _marks; set => _marks = value; }

    }

    internal class MCQ : Questions
    {
        string _Option1;
        string _Option2;
        string _Option3;
        string _Option4;
        string _CorrectAnswer;

        public string Option1 { get => _Option1; set => _Option1 = value; }
        public string Option2 { get => _Option2; set => _Option2 = value; }
        public string Option3 { get => _Option3; set => _Option3 = value; }
        public string Option4 { get => _Option4; set => _Option4 = value; }
        public string CorrectAnswer { get => _CorrectAnswer; set => _CorrectAnswer = value; }
    }

    internal class TrueFalse : Questions
    {
        string _CorrectAnswer;
        public string CorrectAnswer { get => _CorrectAnswer; set => _CorrectAnswer = value; }
    }

    internal class Essay : Questions
    {

    }


}

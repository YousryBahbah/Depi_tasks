namespace task5_c__TheProject_
{
    internal class Program
    {
        static void Main(string[] args)
        {
            
            Course course1 = new Course();
            course1.Title = "Math";
            course1.Description = "Math course";
            course1.Maximum_degree = "100";

            Instructor instructor1 = new Instructor();
            instructor1.ID = 1;
            instructor1.Name = "Mr Smith";
            instructor1.Specialization = "Math";

            Students student1 = new Students();
            student1.ID = 1;
            student1.Name = "Yousry";
            student1.Email = "Yousry@email.com";

            Students student2 = new Students();
            student2.ID = 2;
            student2.Name = "Sara";
            student2.Email = "sara@email.com";

            course1.EnrolledStudent.Add(student1);
            course1.EnrolledStudent.Add(student2);
            course1.Instructor.Add(instructor1);

            student1.EnrolledInCourse.Add(course1);
            student2.EnrolledInCourse.Add(course1);
            instructor1.Teach.Add(course1);

            MCQ question1 = new MCQ();
            question1.Id = 1;
            question1.Text = "What is 5+5?";
            question1.Marks = "10";
            question1.Option1 = "8";
            question1.Option2 = "10";
            question1.Option3 = "12";
            question1.Option4 = "15";
            question1.CorrectAnswer = "10";

            TrueFalse question2 = new TrueFalse();
            question2.Id = 2;
            question2.Text = "Sun is hot";
            question2.Marks = "5";
            question2.CorrectAnswer = "True";

            Essay question3 = new Essay();
            question3.Id = 3;
            question3.Text = "Write about math";
            question3.Marks = "15";

            course1.Question.Add(question1);
            course1.Question.Add(question2);
            course1.Question.Add(question3);

            Exam exam1 = new Exam();
            exam1.Title = "Math Exam";
            exam1.Course = course1;
            exam1.IsStarted = "Yes";
            exam1.Questions.Add(question1);
            exam1.Questions.Add(question2);
            exam1.Questions.Add(question3);

            course1.Exams.Add(exam1);

            Console.WriteLine("Student " + student1.Name + " taking exam:");
            Console.WriteLine("Question 1: " + question1.Text);
            Console.WriteLine("A) " + question1.Option1);
            Console.WriteLine("B) " + question1.Option2);
            Console.WriteLine("C) " + question1.Option3);
            Console.WriteLine("D) " + question1.Option4);
            Console.Write("Your answer: ");
            string answer1 = Console.ReadLine();

            Console.WriteLine("Question 2: " + question2.Text);
            Console.WriteLine("True or False?");
            Console.Write("Your answer: ");
            string answer2 = Console.ReadLine();

            Console.WriteLine("Question 3: " + question3.Text);
            Console.Write("Your answer: ");
            string answer3 = Console.ReadLine();

            int score1 = 0;
            if (answer1 == question1.CorrectAnswer)
            {
                score1 = score1 + 10;
            }
            if (answer2 == question2.CorrectAnswer)
            {
                score1 = score1 + 5;
            }
            if (answer3 != "")
            {
                score1 = score1 + 15;
            }

            student1.Score = score1;
            if (score1 >= 15)
            {
                student1.Pass = "Pass";
            }
            else
            {
                student1.Pass = "Fail";
            }

            Console.WriteLine("\nStudent " + student2.Name + " taking exam:");
            Console.WriteLine("Question 1: " + question1.Text);
            Console.WriteLine("A) " + question1.Option1);
            Console.WriteLine("B) " + question1.Option2);
            Console.WriteLine("C) " + question1.Option3);
            Console.WriteLine("D) " + question1.Option4);
            Console.Write("Your answer: ");
            string answer4 = Console.ReadLine();

            Console.WriteLine("Question 2: " + question2.Text);
            Console.WriteLine("True or False?");
            Console.Write("Your answer: ");
            string answer5 = Console.ReadLine();

            Console.WriteLine("Question 3: " + question3.Text);
            Console.Write("Your answer: ");
            string answer6 = Console.ReadLine();

            int score2 = 0;
            if (answer4 == question1.CorrectAnswer)
            {
                score2 = score2 + 10;
            }
            if (answer5 == question2.CorrectAnswer)
            {
                score2 = score2 + 5;
            }
            if (answer6 != "")
            {
                score2 = score2 + 15;
            }

            student2.Score = score2;
            if (score2 >= 15)
            {
                student2.Pass = "Pass";
            }
            else
            {
                student2.Pass = "Fail";
            }

            Console.WriteLine("\n=== EXAM REPORT ===");
            Console.WriteLine("Exam Title: " + exam1.Title);
            Console.WriteLine("Student Name: " + student1.Name);
            Console.WriteLine("Course Name: " + course1.Title);
            Console.WriteLine("Score: " + student1.Score);
            Console.WriteLine("Pass/Fail: " + student1.Pass);

            Console.WriteLine();
            Console.WriteLine("Exam Title: " + exam1.Title);
            Console.WriteLine("Student Name: " + student2.Name);
            Console.WriteLine("Course Name: " + course1.Title);
            Console.WriteLine("Score: " + student2.Score);
            Console.WriteLine("Pass/Fail: " + student2.Pass);

            Console.WriteLine("\n=== COMPARE STUDENTS ===");
            Console.WriteLine(student1.Name + " score: " + student1.Score);
            Console.WriteLine(student2.Name + " score: " + student2.Score);

            if (student1.Score > student2.Score)
            {
                Console.WriteLine(student1.Name + " scored higher");
            }
            else if (student2.Score > student1.Score)
            {
                Console.WriteLine(student2.Name + " scored higher");
            }
            else
            {
                Console.WriteLine("Both students scored same");
            }

            Console.ReadKey();
        }
    }
}

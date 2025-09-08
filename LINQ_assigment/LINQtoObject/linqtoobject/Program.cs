using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace LINQtoObject
{
    class Program
    {
        static void Main(string[] args)
        {
            //1
            var query1 = SampleData.Books.Select(x => new { x.Title, x.Isbn });
            foreach (var item in query1)
            {
                Console.WriteLine($"the book Title is {item.Title} and the ISBN is {item.Isbn}");
            }
            Console.WriteLine("=================================");
            //2
            var query2 = SampleData.Books.Where(x => x.Price > 25).Take(3);
            Console.WriteLine("The first 3 books worth more than 25");
            foreach (var item in query2)
            {
                Console.WriteLine(item.Title);
            }
            Console.WriteLine("=================================");
            //3
            var query31 = SampleData.Books.Select(x => new { x.Title, x.Publisher });
            var query32 = from book in SampleData.Books
                          select new { book.Title, book.Publisher };
            foreach (var item in query32)
            {
                Console.WriteLine($"{item.Title} , {item.Publisher}");
            }
            Console.WriteLine("=================================");
            //4
            var query41 = SampleData.Books.Where(x => x.Price > 20).Count();
            var query42 = SampleData.Books.Count(x => x.Price > 20);
            //5
            var query5 = SampleData.Books.Select(x => new { x.Title, x.Price, x.Subject }).OrderBy(x => x.Subject).ThenByDescending(x => x.Price);
            //6
            var query61 = SampleData.Books.GroupBy(x => x.Subject);
            //foreach (var group in query61)
            //{
            //    Console.WriteLine($"Subject: {group.Key.Name}");

            //    foreach (var book in group)
            //    {
            //        Console.WriteLine($"{book.Title}");
            //    }
               
               
            //}
            Console.WriteLine("=================================");
            var query62 = from book in SampleData.Books
                          group book by book.Subject into bookgroup
                          select bookgroup;
            //7
            var booklist = SampleData.GetBooks();
            var query7 = booklist.Cast<Book>().Select(x => new {x.Title , x.Price});
            //foreach (var book in query7)
            //{
            //    Console.WriteLine($"the book title is : {book.Title} , price is {book.Price}");
            //}
            Console.WriteLine("=================================");
            //8
            var query = SampleData.Books.GroupBy(x => new { x.Publisher, x.Subject });

            foreach (var group in query)
            {
                Console.WriteLine($"Publisher: {group.Key.Publisher.Name}, Subject: {group.Key.Subject.Name}");

                foreach (var book in group)
                {
                    Console.WriteLine($"{book.Title}");
                }
                //extra training
                var ex1 = SampleData.Books.Where(x => x.PageCount > 500);
                var ex2 = SampleData.Books.Min(x => x.Price);
            }
        }
    }
}

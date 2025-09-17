using CodeFirst_practice.Models;

namespace CodeFirst_practice
{
    internal class Program
    {
        static void Main(string[] args)
        {
            using (var db = new CodeFirstDBContext())
            {
                Console.Write("enter your user name : ");
                string username = Console.ReadLine();

                Console.Write("enter your password : ");
                string pass = Console.ReadLine();

                var user = db.Authors.FirstOrDefault(x => x.Username == username && x.Password == pass);
                if (user != null )
                {
                    Console.WriteLine($"Welcome Back {user.Name}");
                    Console.WriteLine($"your age is {user.Age}");
                    Console.WriteLine($"your joined in :  {user.JoinDate}");

                }
                else
                {
                    Console.WriteLine("user not found");
                }
                if (user != null)
                {
                    Console.WriteLine("which op you want to do : ");
                    Console.WriteLine("1) ADD ");
                    Console.WriteLine("2) DELETE ");
                    Console.WriteLine("3) NONE ");
                    int op = int.Parse(Console.ReadLine());
                    switch (op)
                    {
                        case 1:
                            Console.WriteLine("--- Add a New News Article ---");
                            Console.Write("Enter news title: ");
                            string title = Console.ReadLine();
                            Console.Write("Enter news brief: ");
                            string brief = Console.ReadLine();
                            Console.Write("Enter news description: ");
                            string description = Console.ReadLine();

                            var existingCatalog = db.Catalogs.FirstOrDefault();

                            if (existingCatalog != null)
                            {
                                var newNews = new News
                                {
                                    Title = title,
                                    Description = description,
                                    Breif = brief,
                                    Authorid = user.Id,
                                    Catid = existingCatalog.Id,
                                    time = DateTime.Now,
                                    date = DateOnly.FromDateTime(DateTime.Now)
                                };

                                db.News.Add(newNews);
                                db.SaveChanges();
                                Console.WriteLine("News article added successfully!");
                            }
                            else
                            {
                                Console.WriteLine("Error: No catalogs found in the database. Please add a catalog before adding news.");
                            }
                            break;

                        case 2:
                            Console.WriteLine("--- Delete a News Article ---");
                            Console.WriteLine("Listing your articles:");

                            var myNewsArticles = db.News.Where(n => n.Authorid == user.Id).ToList();

                            if (!myNewsArticles.Any())
                            {
                                Console.WriteLine("You have not created any news articles yet.");
                            }
                            else
                            {
                                foreach (var news in myNewsArticles)
                                {
                                    Console.WriteLine($"ID: {news.Id} | Title: {news.Title}");
                                }

                                Console.Write("Enter the ID of the news article to delete: ");
                                if (int.TryParse(Console.ReadLine(), out int newsIdToDelete))
                                {
                                    var newsToDelete = db.News.FirstOrDefault(n => n.Id == newsIdToDelete && n.Authorid == user.Id);

                                    if (newsToDelete != null)
                                    {
                                        db.News.Remove(newsToDelete);
                                        db.SaveChanges();
                                        Console.WriteLine($"News article with ID {newsIdToDelete} has been deleted successfully.");
                                    }
                                    else
                                    {
                                        Console.WriteLine("Error: News article not found or you do not have permission to delete it.");
                                    }
                                }
                                else
                                {
                                    Console.WriteLine("Invalid input. Please enter a valid ID.");
                                }
                            }
                            break;

                        case 3:
                            Console.ReadKey();
                            break;

                        default:
                            Console.WriteLine("Invalid choice.");
                            break;
                    }
                }
            }
            } 
        }
    }


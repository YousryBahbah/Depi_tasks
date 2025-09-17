using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeFirst_practice.Models
{
    internal class Author
    {
        public int Id { get; set; }
        [Required]
        public string Name { get; set; }
        public int? Age { get; set; }
         public DateOnly? JoinDate { get; set; }
        [Required]
        public string Username { get; set; }
        [Required]
        public string Password { get; set; }

        public ICollection<News> News { get; } = new List<News>();
    }
}

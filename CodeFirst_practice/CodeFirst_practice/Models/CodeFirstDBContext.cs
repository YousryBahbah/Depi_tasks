using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeFirst_practice.Models
{
    internal class CodeFirstDBContext :DbContext
    {
        public DbSet<Author> Authors { get; set; }
        public DbSet<Catalog> Catalogs { get; set; }
        public DbSet<News> News { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("Server=YOUSRY-BAHBAH\\SQLEXPRESS;Database=CodeFirstAssignment;Trusted_Connection=True;Integrated Security = True;TrustServerCertificate=True;");
        }
    }
}

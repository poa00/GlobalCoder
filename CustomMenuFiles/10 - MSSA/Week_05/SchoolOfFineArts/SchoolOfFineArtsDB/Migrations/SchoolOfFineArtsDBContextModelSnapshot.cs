﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using SchoolOfFineArtsDB;

#nullable disable

namespace SchoolOfFineArtsDB.Migrations
{
    [DbContext(typeof(SchoolOfFineArtsDBContext))]
    partial class SchoolOfFineArtsDBContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.10")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder, 1L, 1);

            modelBuilder.Entity("SchoolOfFineArtsModels.Course", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Abbreviation")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.Property<string>("Department")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.Property<int>("NumCredits")
                        .HasColumnType("int");

                    b.Property<int>("TeacherId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("TeacherId");

                    b.ToTable("Courses", (string)null);
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.CourseEnrollment", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<int>("CourseId")
                        .HasColumnType("int");

                    b.Property<int>("StudentId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("CourseId");

                    b.HasIndex("StudentId", "CourseId")
                        .IsUnique();

                    b.ToTable("CourseEnrollment", (string)null);
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.Student", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<DateTime>("DateOfBirth")
                        .HasColumnType("datetime2");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.HasKey("Id");

                    b.ToTable("Students", (string)null);

                    b.HasData(
                        new
                        {
                            Id = 1,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Greg",
                            LastName = "John"
                        },
                        new
                        {
                            Id = 2,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Erik",
                            LastName = "Tabaka"
                        },
                        new
                        {
                            Id = 3,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Josh",
                            LastName = "Benson"
                        },
                        new
                        {
                            Id = 4,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Alex",
                            LastName = "Robinson"
                        },
                        new
                        {
                            Id = 5,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Mark",
                            LastName = "Rimbaugh"
                        },
                        new
                        {
                            Id = 6,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "David",
                            LastName = "Diaz Morales"
                        },
                        new
                        {
                            Id = 7,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Andrew",
                            LastName = "Nelson"
                        },
                        new
                        {
                            Id = 8,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Brian",
                            LastName = "Braine"
                        },
                        new
                        {
                            Id = 9,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Donovan",
                            LastName = "Zeanah"
                        },
                        new
                        {
                            Id = 10,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Jackson",
                            LastName = "Freiburg"
                        },
                        new
                        {
                            Id = 11,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Joshua",
                            LastName = "Benson"
                        },
                        new
                        {
                            Id = 12,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Mursal",
                            LastName = "Qaderyan"
                        },
                        new
                        {
                            Id = 13,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Rohin",
                            LastName = "Qaderyan"
                        },
                        new
                        {
                            Id = 14,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Rico",
                            LastName = "Rodriguez"
                        },
                        new
                        {
                            Id = 15,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Tom",
                            LastName = "Brady"
                        },
                        new
                        {
                            Id = 16,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Aaron",
                            LastName = "Rogers"
                        },
                        new
                        {
                            Id = 17,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Dax",
                            LastName = "Prescott"
                        },
                        new
                        {
                            Id = 18,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Joe",
                            LastName = "Burrow"
                        },
                        new
                        {
                            Id = 19,
                            DateOfBirth = new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                            FirstName = "Trevor",
                            LastName = "Lawrence"
                        });
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.Teacher", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<int>("Age")
                        .HasColumnType("int");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.HasKey("Id");

                    b.ToTable("Teachers", (string)null);

                    b.HasData(
                        new
                        {
                            Id = 1,
                            Age = 27,
                            FirstName = "Anne",
                            LastName = "Sullivan"
                        },
                        new
                        {
                            Id = 2,
                            Age = 32,
                            FirstName = "Maria",
                            LastName = "Montessori"
                        },
                        new
                        {
                            Id = 3,
                            Age = 21,
                            FirstName = "William",
                            LastName = "McGuffey"
                        },
                        new
                        {
                            Id = 4,
                            Age = 47,
                            FirstName = "Emma",
                            LastName = "Willard"
                        },
                        new
                        {
                            Id = 5,
                            Age = 64,
                            FirstName = "Tom",
                            LastName = "Hanks"
                        },
                        new
                        {
                            Id = 6,
                            Age = 62,
                            FirstName = "Tom",
                            LastName = "Cruise"
                        },
                        new
                        {
                            Id = 7,
                            Age = 57,
                            FirstName = "Val",
                            LastName = "Kilmer"
                        },
                        new
                        {
                            Id = 8,
                            Age = 48,
                            FirstName = "Geena",
                            LastName = "Davis"
                        },
                        new
                        {
                            Id = 9,
                            Age = 37,
                            FirstName = "Chris",
                            LastName = "Pratt"
                        },
                        new
                        {
                            Id = 10,
                            Age = 42,
                            FirstName = "Anne",
                            LastName = "Hathaway"
                        });
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.Course", b =>
                {
                    b.HasOne("SchoolOfFineArtsModels.Teacher", "Teacher")
                        .WithMany("Courses")
                        .HasForeignKey("TeacherId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Teacher");
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.CourseEnrollment", b =>
                {
                    b.HasOne("SchoolOfFineArtsModels.Course", "Course")
                        .WithMany("CourseEnrollments")
                        .HasForeignKey("CourseId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("SchoolOfFineArtsModels.Student", "Student")
                        .WithMany("CourseEnrollments")
                        .HasForeignKey("StudentId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Course");

                    b.Navigation("Student");
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.Course", b =>
                {
                    b.Navigation("CourseEnrollments");
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.Student", b =>
                {
                    b.Navigation("CourseEnrollments");
                });

            modelBuilder.Entity("SchoolOfFineArtsModels.Teacher", b =>
                {
                    b.Navigation("Courses");
                });
#pragma warning restore 612, 618
        }
    }
}

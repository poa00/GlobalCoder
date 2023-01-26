using BalancedStringCheckUtility;
using Microsoft.VisualStudio.TestPlatform.TestHost;
using Shouldly;
using Xunit;

namespace TestMatchingParensBalancing
{
    public class CheckStrings
    {
        [Theory]
        [InlineData("{ ( [ ] ) }", true)]
        [InlineData("{ ( ] [ ) }", true)]
        [InlineData("{ ( [ ) ] }", false)]
        [InlineData("{ ( ( ] ) }", false)]
        [InlineData("{ ( [ { ( [ { ( [ ] ) }] ) }] ) }", true)]
        [InlineData("{ ( [ { ( [ { ( [ { ( [ { ( [ ] ) }] ) }] ) }{ ( [ ] ) }] ) }] ) }", false)]
        [InlineData("{ ( [ { ( [ { ( [ { ( [ ) ] } ] ) }] ) }] ) }", false)]
        [InlineData("{ ( [ { ( { ( ( ] ) } [ { ( [ ] ) }] ) }] ) }", false)]
        /*
        





{ It began with ( the forging of [the Great Rings. ] Three were given to the Elves), immortal, wisest and fairest of all beings.}
{ Seven to the Dwarf-Lords,( great miners  [ and ] craftsmen of the mountain halls.) }
{ And nine, ( [  nine rings were gifted ] to the race of Men,) who above all else desire power. }
{ For within these rings was bound the strength and the will to govern each race. ( [ But they were all of them deceived, ) for another ring was made. ] }
{ Deep in the land of Mordor, in the Fires of Mount Doom,( the Dark Lord Sauron forged a master ring,( and into this ring he poured his cruelty,] his malice and his will ) to dominate all life.}
        */
        //[InlineData("{ ( ] [ ) }", false)]
        public void TestIsBalancedList(string testString, bool expected)
        {
            var bcs = new BalancedStringCheck();
            var result = bcs.IsBalancedStringList(testString);
            result.ShouldBeEquivalentTo(expected);
        }
    }
}
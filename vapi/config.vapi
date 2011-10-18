/*
 * Puzzle!
 * Copyright © 2011 Kamil Prusko <kamilprusko@gmail.com>
 *
 * Puzzle! is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Puzzle! is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this game.  If not, see <http://www.gnu.org/licenses/>.
 */

[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "config.h")]
namespace Config
{
    /* Define to the short name of this package. */
    public const string PACKAGE_NAME;

    /* Define to the full name of this package. */
    public const string PACKAGE_FULL_NAME;

    /* Define to the full name and version of this package. */
    public const string PACKAGE_STRING;

    /* Define to the version of this package. */
    public const string PACKAGE_VERSION;

    /* Define to the address where bug reports for this package should be sent. */
    public const string PACKAGE_BUGREPORT;

    /* Define to the home page for this package. */
    public const string PACKAGE_URL;

    public const string PACKAGE_DATADIR;

    public const string PACKAGE_LOCALEDIR;

    public const string GETTEXT_PACKAGE;


    public const bool HAVE_CLUTTER_GESTURE;
    public const bool HAVE_CLUTTER_BOX2D;

    public const string VERSION;
//    public const string API_VERSION;

    public const bool DEBUG;
}


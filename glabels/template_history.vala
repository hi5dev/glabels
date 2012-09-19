/*  template_history.vala
 *
 *  Copyright (C) 2011  Jim Evins <evins@snaught.com>
 *
 *  This file is part of gLabels.
 *
 *  gLabels is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  gLabels is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with gLabels.  If not, see <http://www.gnu.org/licenses/>.
 */


using GLib;

namespace glabels
{

	public class TemplateHistory : Object
	{

		public signal void changed();

		private static GLib.Settings history;
		private int                  max_n;

		static construct
		{
			history = new GLib.Settings( "org.gnome.glabels-4.history" );
		}

		public TemplateHistory( int n )
		{
			max_n = n;

			history.changed["recent-templates"].connect( on_history_changed );
		}

		public void add_name( string template_name )
		{
			string[] old_templates;
			string[] new_templates;

			old_templates = history.get_strv( "recent-templates" );

			new_templates = new string[1];
			new_templates[0] = template_name;

			for ( int i = 0; (i < (max_n-1)) && (i < old_templates.length); i++ )
			{
				if ( template_name != old_templates[i] )
				{
					new_templates += old_templates[i];
				}
			}

			history.set_strv( "recent-templates", new_templates );
		}

		public List<string> get_template_list()
		{
			List<string> template_list = new List<string>();

			string[] templates = history.get_strv( "recent-templates" );

			for ( int i = 0; i < templates.length; i++ )
			{
				template_list.append( templates[i] );
			}

			return template_list;
		}

		private void on_history_changed()
		{
			changed();
		}

	}

}


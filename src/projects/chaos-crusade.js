import React, { Component } from 'react';
import Project from 'components/project';
import GalleryImage from 'components/galleryImage';

export default class ChaosCrusade extends Component {
	render() {
		return (
			<Project>
				<div className={'row'}>
					<div className={'col-md-8'}>
						<h2>Chaos Crusade</h2>
						<p>
							Like a lot of my personal projects Chaos Crusade is unfinished and on indefinite hold. I started it when my friends and I were playing a pen and paper game, while fighting a Google Spreadsheet for character progression tracking. Google Docs offered multi-user real-time updates, which was nice, but a spreadsheet just didn't offer enough guidance for what we were doing. Chaos Crusade was my answer to these problems, but I stopped working on it when we stopped playing the game. 
						</p>
					</div>
					<div className={'col-md-4'}>
						<GalleryImage src="/assets/images/chaos_char.jpg" alt="The character screen, adding a skill" />
					</div>
				</div>
				<div className={'row'}>
					<div className={'col-md-8'}>
						<p>
							The reason I am inlcuding this unfinished work here is that I am particularly proud of the central data-sync mechanism that I built for it. It was initially inspired by Meteor, which offers a very similiar system, but was built to integrate with Knockout's data-binding. I don't really like the Backbone-style template system Meteor uses, but I love Knockout. The data-sync ensures that any changes made to a local client are sent to the server, and then to every other active client via Socket.IO. This creates real-time data synchronization between clients. The whole thing is neatly abstracted so that the code using the socket-backed Knockout Objects and Array's can't tell the difference after constructing them. They data-bind and update the same API that you would use for a standard Knockout observable or observableArray. It easily supports any data structure, and adding new "collections" is just a couple lines of code on the server.
						</p>
						<p>
							The source code is hosted on <a href="https://github.com/tyrsius/chaoscrusade" target="_blank">Github</a>, and a live demo can be seen <a href="http://chaos.tyrsius.com/" target="_bank">here</a> (sign in with guest/guest). If you want to see the data-sync in action, just open two tabs (or two browsers).
						</p>
					</div>
					<div className={'col-md-4'}>
						<GalleryImage src="/assets/images/chaos_skill.jpg" alt="The skill entry interface." />
					</div>
				</div>
			</Project>
		);
	}
}